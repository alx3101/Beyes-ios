//
//  Dependencies.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .init()
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}

class Interactors: ObservableObject {
    @ObservedObject var auth: AuthInteractor
    let shopInteractor: ShopInteractor

    init(services: Services) {
        auth = AuthInteractor(authServices: services.authServices)
        shopInteractor = ShopInteractor(service: services.shopsServices)
    }
}

class Services: ObservableObject {
    fileprivate let networkServices: NetworkServices
    let shopsServices: ShopServices
    let supabase: SupabaseServices
    let authServices: AuthServices

    init() {
        supabase = SupabaseServices()
        authServices = AuthServices(client: supabase.client)
        networkServices = NetworkServices(supabase: supabase.client, refreshToken: authServices.refreshSession)
        shopsServices = ShopServices(networkServices: networkServices)
    }
}

final class AppEnvironment: ObservableObject {
    let interactors: Interactors
    let services: Services

    init() {
        services = Services()
        interactors = Interactors(services: services)
    }
}
