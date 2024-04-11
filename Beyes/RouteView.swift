//
//  RouteView.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var routing: Router

    init(rootNode: AppRoute) {
        _routing = StateObject(wrappedValue: Router(rootNode: rootNode))
    }

    var body: some View {
        NavigationView {
            VStack {
                routing.currentRoute.getView()
            }
            .environmentObject(routing)
        }
    }
}

class Router: ObservableObject {
    @Published var routeStack: [AppRoute] = []

    init(rootNode: AppRoute) {
        routeStack = [rootNode]
    }

    var currentRoute: AppRoute {
        routeStack.last ?? .home
    }

    func push(route: AppRoute) {
        routeStack.append(route)
    }

    func pop() {
        guard routeStack.count > 1 else {
            return
        }
        _ = routeStack.popLast()
    }

    func setMain(_ route: AppRoute) {
        routeStack.removeAll()
        routeStack.append(route)
    }
}
