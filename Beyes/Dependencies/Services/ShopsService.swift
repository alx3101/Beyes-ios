//
//  ShopsService.swift
//  Beyes
//
//  Created by Alex Popa on 07/04/24.
//

import Foundation
import Supabase

protocol ShopServicesProtocol {
    func getAllShops() async throws -> [Shop]
    func getShops(with ids: [String]) async throws -> [Shop]
    func getShop(with id: String) async throws -> Shop
}

class ShopServices: ShopServicesProtocol {
    let networkServices: NetworkServices

    init(networkServices: NetworkServices) {
        self.networkServices = networkServices
    }

    func getAllShops() async throws -> [Shop] {
        let data: [Shop] = try await networkServices.request(request: .get(), schema: .pub, endpoint: .shops)
        print("Fetched data \(data)")
        return data
    }

    func getShops(with ids: [String]) async throws -> [Shop] {
        let data: [Shop] = try await networkServices.request(request: .get(column: Shop.Columns.id, filters: ids), schema: .pub, endpoint: .shops)
        return data
    }

    func getShop(with id: String) async throws -> Shop {
        let data: Shop = try await networkServices.request(request: .get(column: Shop.Columns.id, filters: [id]), schema: .pub, endpoint: .shops)
        return data
    }
}
