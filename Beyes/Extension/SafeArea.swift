//
//  SafeArea.swift
//  Beyes
//
//  Created by Alex Popa on 15/04/24.
//

import Foundation
import SwiftUI

func hasSafeArea() -> Bool {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first else {
        return false
    }

    let safeAreaInsets = window.safeAreaInsets

    return safeAreaInsets.top > 0 || safeAreaInsets.bottom > 0 || safeAreaInsets.left > 0 || safeAreaInsets.right > 0
}
