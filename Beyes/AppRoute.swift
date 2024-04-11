//
//  AppRoute.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

enum AppRoute {
    case splash
    case home

    @ViewBuilder
    func getView() -> some View {
        switch self {
        case .home:
            HomeView()
        case .splash:
            Splash()
        }
    }
}
