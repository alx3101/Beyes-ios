//
//  Shop.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import Foundation
import MapKit

struct Shop: Codable, Equatable, Hashable, Identifiable {
    let brand: String
    let brandID: UUID
    let numberPhone: Int?
    let sensorID: UUID
    let numberOfSensors: Int
    let address: String
    let coordinates: [Double]
    let isShopPartner: Bool
    let id: UUID
    let addedAt: Date
    let city: String
    let businessHours: [String]

    enum CodingKeys: String, CodingKey {
        case brand = "brand_name"
        case brandID = "brand_id"
        case numberPhone = "number_phone"
        case sensorID = "sensor_id"
        case numberOfSensors = "number_sensor"
        case address = "shop_address"
        case coordinates = "shop_coordinates"
        case isShopPartner = "shop_partner"
        case id
        case addedAt = "added_at"
        case city = "shop_city"
        case businessHours = "business_hours"
    }

    static func mock() -> Shop {
        .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: [])
    }

    enum Columns {
        static let brandName = "brand_name"
        static let brandID = "brand_id"
        static let sensorID = "sensor_id"
        static let numberSensor = "number_sensor"
        static let shopAddress = "shop_address"
        static let coordinates = "shop_coordinates"
        static let shopPartner = "shop_partner"
        static let id = "id"
        static let addedAt = "added_at"
        static let city = "shop_city"
        static let businessHours = "business_hours"
    }
}

extension [Shop] {
    static func mocks() -> [Shop] {
        [.init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: []),
         .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: []),
         .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: []),
         .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: []),
         .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: []),
         .init(brand: "Brand test", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 2, address: "Test address", coordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, city: "City test", businessHours: [])]
    }

    func convert() async throws -> [Shop] {
        var shops: [Shop] = []
        for shop in self {
            let location = CLLocationCoordinate2D(latitude: shop.coordinates.first ?? 0.0, longitude: shop.coordinates.last ?? 0.0)
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = shop.brand
            searchRequest.region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            let search = MKLocalSearch(request: searchRequest)
            
            let response = try await search.start()
            guard let firstItem = response.mapItems.first else {
                print("No results found")
                return self
            }
            
            let shop = Shop.init(brand: firstItem.name!, brandID: shop.brandID, numberPhone: shop.numberPhone, sensorID: shop.sensorID, numberOfSensors: shop.numberOfSensors, address: firstItem.placemark.title!, coordinates: [firstItem.placemark.coordinate.latitude,firstItem.placemark.coordinate.longitude], isShopPartner: shop.isShopPartner, id: shop.id, addedAt: shop.addedAt, city: shop.city, businessHours: shop.businessHours)
            shops.append(shop)
        }
        return shops
    }
}
