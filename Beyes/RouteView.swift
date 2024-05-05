//
//  RouteView.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

struct RouterView: View {
    @StateObject var router: Router = .init(rootViewContent: AnyView(Splash()))
    // Our root view content

    var body: some View {
        NavigationStack(path: $router.path) {
            router.rootViewContent
                .navigationDestination(for: AppRoute.self) { route in
                    route.view()
                }
        }
        .environmentObject(router)
    }
}

class Router: ObservableObject {
    // Used to programatically control our navigation stack
    @Published var path: NavigationPath = .init()
    @Published var rootViewContent: AnyView

    init(rootViewContent: AnyView) {
        self.rootViewContent = rootViewContent
    }

    func setMain(_ route: AppRoute) {
        withAnimation(.easeIn) {
            rootViewContent = AnyView(route.view())
        }
    }

    // Used by views to navigate to another view
    func navigateTo(_ route: AppRoute) {
        path.append(route)
    }

    // Used to go back to the previous screen
    func pop() {
        path.removeLast()
    }

    // Pop to the root screen in our hierarchy
    func popToRoot() {
        path.removeLast(path.count)
    }
}
