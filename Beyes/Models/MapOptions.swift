//
//  MapOptions.swift
//  Beyes
//
//  Created by Alex Popa on 22/05/24.
//

import Foundation
import MapKit

enum MapOptions: String, CaseIterable {
    case waze = "Waze"
    case apple = "Apple"
    case google = "Google"

    func navigate(to shop: Shop) {
        guard let latitude = shop.coordinates.first,
              let longitude = shop.coordinates.last else {
            return
        }

        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = shop.brand
        searchRequest.region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            if let firstItem = response?.mapItems.first {
                self.openMap(with: firstItem)
            } else {
                self.openMapFallback(to: shop, latitude: latitude, longitude: longitude)
            }
        }
    }

    private func openMap(with mapItem: MKMapItem) {
        let coordinateString = "\(mapItem.placemark.coordinate.latitude),\(mapItem.placemark.coordinate.longitude)"
        let name = mapItem.name ?? ""
        let address = mapItem.placemark.title ?? ""

        let urlString: String
        switch self {
        case .waze:
            urlString = "https://waze.com/ul?q=\(name)&ll=\(coordinateString)&navigate=yes"
        case .apple:
            mapItem.openInMaps()
            return
        case .google:
            urlString = "https://www.google.com/maps?q=\(name),\(address)&g_st=ia"
        }

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    private func openMapFallback(to shop: Shop, latitude: Double, longitude: Double) {
        let coordinateString = "\(latitude),\(longitude)"
        let queryString = shop.brand
        let address = shop.address

        let urlString: String = switch self {
        case .waze:
            "https://waze.com/ul?q=\(queryString)&ll=\(coordinateString)&navigate=yes"
        case .apple:
            "https://maps.apple.com/?address=\(address)&ll=\(coordinateString)&q=\(queryString)"
        case .google:
            "https://www.google.com/maps?q=\(queryString),\(address)&g_st=ia"
        }

        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
