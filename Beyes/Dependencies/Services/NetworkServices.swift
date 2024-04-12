//
//  NetworkServices.swift
//  Beyes
//
//  Created by Alex Popa on 09/04/24.
//

import Foundation
import Supabase

// Enum defining different endpoint requests
enum EndpointRequest: String {
    case brands = "Brands"
    case shops = "Shops_Structures"
}

enum EndpointSchema: String {
    case stores
    case pub = "public"
}

// Enum defining different types of network requests with associated data
enum Request<T> {
    case get(column: String? = nil, filters: [String]? = nil)
    case post(data: T)
    case update(data: T, id: UUID)
    case delete(id: UUID)
}

// Protocol defining the network services contract
protocol NetworkServicesProtocol {
    associatedtype ResponseType
    func request<T: Codable>(request: Request<T>, schema: EndpointSchema, endpoint: EndpointRequest) async throws -> T
}

// Concrete implementation of the network services protocol
class NetworkServices: NetworkServicesProtocol {
    typealias ResponseType = Any // You can specify the data type you want as a response

    let supabase: SupabaseClient
    private let refreshToken: () async throws -> Void

    init(supabase: SupabaseClient,
         refreshToken: @escaping () async throws -> Void) {
        self.supabase = supabase
        self.refreshToken = refreshToken
    }

    func request<T: Codable>(request: Request<T>, schema: EndpointSchema, endpoint: EndpointRequest) async throws -> T {
        debugPrint("Request: \(request) schema \(schema) to endpoint \(endpoint)")
        do {
            switch request {
            case let .get(column, filters):
                // Perform a GET request

                guard let column = column,
                      let filters = filters
                else {
                    // Retrieve all the data if columns or filter is nill
                    let data: T = try await supabase.database
                        .schema(schema.rawValue)
                        .from(endpoint.rawValue)
                        .select()
                        .execute()
                        .value

                    debugPrint("Request: \(request) schema \(schema) to endpoint \(endpoint) = \(data)")
                    return data
                }

                let filteredData: T = try await supabase.database
                    .schema(schema.rawValue)
                    .from(endpoint.rawValue)
                    .select(column)
                    .in(column, value: filters)
                    .execute()
                    .value

                debugPrint("Request: \(request) schema \(schema) to endpoint \(endpoint) = \(filteredData)")

                return filteredData

            case let .post(data):
                // Perform a POST request with the provided data
                // Retrieve the data directly
                return try await supabase.database
                    .from(endpoint.rawValue)
                    .insert(data)
                    .execute()
                    .value
            case let .update(data, id):
                // Perform an update request with the provided data and specified ID
                // Retrieve the data directly
                return try await supabase.database
                    .from(endpoint.rawValue)
                    .update(data)
                    .eq("id", value: id)
                    .execute()
                    .value
            case let .delete(id):
                // Perform a delete request with the specified ID
                // Retrieve the data directly
                return try await supabase.database
                    .from(endpoint.rawValue)
                    .delete()
                    .eq("id", value: id)
                    .execute()
                    .value
            }
        } catch {
            // If an error occurs, throw the exception to be handled externally
            if let error = error as? APIError,
               case let .httpCode(code) = error,
               code == 401 {
                do {
                    try await refreshToken()
                } catch {
                    throw APIError.tokenRefresh
                }
                return try await self.request(request: request, schema: schema, endpoint: endpoint)
            } else {
                throw error
            }
        }
    }
}
