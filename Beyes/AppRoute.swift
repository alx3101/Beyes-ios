//
//  AppRoute.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable, Identifiable {
    var id: Int {
        hashValue
    }

    case splash
    case login
    case registration
    case home
    case shopDetail(Shop, Binding<Int>)

    @ViewBuilder func view() -> some View {
        switch self {
        case .splash:
            Splash()
        case .home:
            HomeView()
        case .login:
            LoginView()
        case .registration:
            RegistrationView()
        case let .shopDetail(shop, customers):
            ShopDetail(shop: shop, customers: customers)
        }
    }
}
