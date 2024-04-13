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

class ViewModels: ObservableObject {
    @ObservedObject var authentication: AuthViewModel

    init(services: Services) {
        authentication = AuthViewModel(authServices: services.authServices)
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
    let viewModels: ViewModels
    let services: Services

    init() {
        services = Services()
        viewModels = ViewModels(services: services)
    }
}
