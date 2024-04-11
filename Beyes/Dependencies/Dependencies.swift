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

class ViewModels: ObservableObject {}
class Services: ObservableObject {
    fileprivate let networkServices: NetworkServices
    let ShopsServices: ShopServices
    let supabase: SupabaseServices

    init() {
        supabase = SupabaseServices()
        networkServices = NetworkServices(supabase: supabase.client)
        ShopsServices = ShopServices(networkServices: networkServices)
    }
}

final class AppEnvironment: ObservableObject {
    let viewModels: ViewModels
    let services: Services

    init() {
        viewModels = ViewModels()
        services = Services()
    }
}
