//
//  Font.swift
//  Beyes
//
//  Created by Alex Popa on 30/04/24.
//

import Foundation
import SwiftUI

extension Text {
    // Font weight = 300
    func light(size: CGFloat = 16, color: Color = .white) -> Self {
        font(.system(size: size, weight: .light))
            .foregroundColor(color)
    }

    // Font weight = 400
    func regular(size: CGFloat = 16, color: Color = .white) -> Self {
        font(.system(size: size, weight: .regular))
            .foregroundColor(color)
    }

    // Font weight = 500
    func medium(size: CGFloat = 18, color: Color = .white) -> Self {
        font(.system(size: size, weight: .medium))
            .foregroundColor(color)
    }

    // Font weight = 600
    func semiBold(size: CGFloat = 18, color: Color = .white) -> some View {
        font(.system(size: size, weight: .semibold))
            .foregroundColor(color)
    }

    // Font weight = 700
    func bold(size: CGFloat = 18, color: Color = .white) -> some View {
        font(.system(size: size, weight: .bold))
            .foregroundColor(color)
    }
}
