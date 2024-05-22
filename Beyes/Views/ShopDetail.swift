//
//  ShopDetail.swift
//  Beyes
//
//  Created by Alex Popa on 05/05/24.
//

import BottomSheet
import MapKit
import SwiftUI

struct ShopDetail: View {
    @EnvironmentObject var router: Router
    @State private var isFavorite = false
    @State private var showAdditionalStatistics = false
    @Binding var customers: Int
    @State private var mapBottomSheet: BottomSheetPosition = .hidden

    let shop: Shop

    init(shop: Shop, customers: Binding<Int>) {
        _customers = customers
        self.shop = shop
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.5), Color.clear]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Intestazione con il nome del negozio
                    HStack {
                        Button { router.pop() } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                        }

                        Spacer()

                        Text(shop.brand)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Spacer()
                    }

                    // Mappa
                    MapView(location: CLLocationCoordinate2D(latitude: shop.coordinates.first ?? 0.0,
                                                             longitude: shop.coordinates.last ?? 0.0))
                        .frame(height: 200)
                        .cornerRadius(10)

                    HStack(spacing: 20) {
                        NavigationButton(imageName: "bell") {
                            // Logica per aprire Waze
                            isFavorite.toggle()
                        }

                        NavigationButton(imageName: "phone.fill") {}

                        NavigationButton(imageName: isFavorite ? "star.fill" : "star") {
                            isFavorite.toggle()
                        }

                        NavigationButton(imageName: "map.fill") {
                            mapBottomSheet = .dynamic
                        }

                        NavigationButton(imageName: "globe") {
                            isFavorite.toggle()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    statisticsView

                    VStack(alignment: .leading, spacing: 10) {
                        informationRow(title: "Address", shop.address)

                        Text("Orari di apertura:")
                            .font(.headline)
                        Text(shop.businessHours.first ?? "")
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal, 16)
            }
        }
        .bottomSheet(bottomSheetPosition: $mapBottomSheet, switchablePositions: [], content: {
            mapOptionsSheet
        })
        .enableTapToDismiss()
        .showDragIndicator(false)
        .navigationBarBackButtonHidden()
    }
}

private extension ShopDetail {
    struct NavigationButton: View {
        let imageName: String
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                Image(systemName: imageName)
                    .font(.title)
                    .frame(height: 30)
                    .padding(10)
                    .background(.regularMaterial)
                    .cornerRadius(10)
            }
        }
    }

    struct MapView: UIViewRepresentable {
        let location: CLLocationCoordinate2D

        func makeUIView(context _: Context) -> MKMapView {
            MKMapView(frame: .zero)
        }

        func updateUIView(_ view: MKMapView, context _: Context) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            view.addAnnotation(annotation)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            view.setRegion(region, animated: true)
        }
    }

    @ViewBuilder
    func informationRow(title: String, _ data: String) -> some View {
        HStack {
            Text("\(title):")
                .font(.headline)
            Text(data)

            Spacer()
        }
    }

    @ViewBuilder
    func statisticRow<T: CustomStringConvertible>(title: String, _ value: Binding<T>) -> some View {
        HStack {
            Text("\(title):")
            Text("\(value.wrappedValue.description)")
            Spacer()
        }
    }

    @ViewBuilder
    var statisticsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                statisticRow(title: "Actual customers", $customers)

                Button(action: {
                    withAnimation(.interactiveSpring()) { showAdditionalStatistics.toggle()
                    }
                }, label: {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(showAdditionalStatistics ? -180.0 : 0))

                })
            }

            if showAdditionalStatistics {}
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        }
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    var mapOptionsSheet: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(minHeight: 1)

            ForEach(MapOptions.allCases, id: \.self) { option in

                Button {
                    self.mapBottomSheet = .hidden
                    option.navigate(to: shop)
                } label: {
                    VStack(spacing: 0) {
                        Text(option.rawValue)
                            .font(.system(size: 20))
                            .padding(20)
                    }
                    .frame(maxWidth: .infinity)
                }

                Divider()
                    .frame(minHeight: 1)
            }

            Spacer().frame(height: 20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }

}

#Preview(body: {
    ShopDetail(shop: .init(brand: "Unieuro", brandID: UUID(), numberPhone: nil, sensorID: UUID(), numberOfSensors: 1, address: "Via carlo ciccio", coordinates: [], isShopPartner: false, id: UUID(), addedAt: .now, city: "test", businessHours: [""]), customers: .constant(0))
})
