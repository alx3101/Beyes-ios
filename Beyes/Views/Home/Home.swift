//
//  Home.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appEnvironment) var appEnvironment
    @EnvironmentObject var router: Router

    let columns = Array(repeating: GridItem(.flexible()), count: 3)

    @State private var data: Loadable<[Shop]> = .notRequested
    @State private var shops: [Shop] = []

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.5), Color.clear]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                Text("home")

                switch data {
                case .notRequested:
                    Text("")
                        .onAppear {
                            loadData()
                        }
                case .loading:
                    LoadingView()
                case let .loaded(value):
                    loadedView(value)
                case let .failed(error):
                    Text(error.localizedDescription)
                }
            }
        }
        .onReceive(appEnvironment.interactors.auth.$currentSession, perform: { value in
            if !(value ?? false) {
                router.setMain(.login)
            }

        })
    }
}

private extension HomeView {
    @ViewBuilder
    func loadedView(_ shops: [Shop]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                DragList($shops) { shop in
                    HomeCell(shop: shop)
                        .onTapGesture {
                            router.navigateTo(.shopDetail(shop,
                                                          .constant(10)))
                        }
                }
            })
            .padding(.horizontal, 8)
            .padding(.top, 16)
        }
    }
}

private extension HomeView {
    func loadData() {
        appEnvironment.interactors.shopInteractor.getShops {
            if case let .loaded(data) = $0 {
                shops = data
            }
            data = $0
        }
    }
}

#Preview {
    HomeView()
}
