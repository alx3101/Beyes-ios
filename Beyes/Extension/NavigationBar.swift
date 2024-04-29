//
//  NavigationBar.swift
//  Beyes
//
//  Created by Alex Popa on 29/04/24.
//

import Foundation
import UIKit

extension UINavigationBar {
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()

        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.backgroundColor = .white
            appearance.shadowColor = .white
        }

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
