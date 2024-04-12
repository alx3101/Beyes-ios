//
//  APIErrors.swift
//  Beyes
//
//  Created by Alex Popa on 12/04/24.
//

import Foundation

public enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageProcessing([URLRequest])
    case tokenRefresh
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case let .httpCode(code):
            return "Unexpected HTTP code: \(code)"
        case .unexpectedResponse:
            return "Unexpected response from the server"
        case .imageProcessing:
            return "Unable to load image"
        case .tokenRefresh:
            return "Token refresh failed"
        }
    }
}

public typealias HTTPCode = Int
public typealias HTTPCodes = Range<HTTPCode>

public extension HTTPCodes {
    static let success = 200 ..< 300
}
