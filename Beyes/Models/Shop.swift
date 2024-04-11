//
//  Shop.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import Foundation

struct Shop: Codable {
    let brandName: String
    let brandID: UUID
    let sensorID: UUID
    let numberOfSensors: Int
    let shopAddress: String
    let shopCoordinates: [Double]
    let isShopPartner: Bool
    let id: UUID
    let addedAt: Date
    let shopCity: String
    let businessHours: [String]

    enum CodingKeys: String, CodingKey {
        case brandName = "brand_name"
        case brandID = "brand_id"
        case sensorID = "sensor_id"
        case numberOfSensors = "number_sensor"
        case shopAddress = "shop_address"
        case shopCoordinates = "shop_coordinates"
        case isShopPartner = "shop_partner"
        case id
        case addedAt = "added_at"
        case shopCity = "shop_city"
        case businessHours = "business_hours"
    }

    static func mock() -> Shop {
        .init(brandName: "Brand test", brandID: UUID(), sensorID: UUID(), numberOfSensors: 2, shopAddress: "Test address", shopCoordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, shopCity: "City test", businessHours: [])
    }

    static func mocks() -> [Shop] {
        [.init(brandName: "Brand test", brandID: UUID(), sensorID: UUID(), numberOfSensors: 2, shopAddress: "Test address", shopCoordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, shopCity: "City test", businessHours: []),
         .init(brandName: "Brand test", brandID: UUID(), sensorID: UUID(), numberOfSensors: 2, shopAddress: "Test address", shopCoordinates: [], isShopPartner: false, id: UUID(), addedAt: Date.now, shopCity: "City test", businessHours: [])]
    }

    enum Columns {
        static let brandName = "brand_name"
        static let brandID = "brand_id"
        static let sensorID = "sensor_id"
        static let numberSensor = "number_sensor"
        static let shopAddress = "shop_address"
        static let shopCoordinates = "shop_coordinates"
        static let shopPartner = "shop_partner"
        static let id = "id"
        static let addedAt = "added_at"
        static let shopCity = "shop_city"
        static let businessHours = "business_hours"
    }
}
