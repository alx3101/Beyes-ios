//
//  Splash.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

struct Splash: View {
    var body: some View {
        VStack {
            Text("Beyes")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color(red: 0 / 255, green: 110 / 255, blue: 255 / 255),
                        Color(red: 0 / 255, green: 212 / 255, blue: 255 / 255),
                    ]
                ),
                startPoint: .bottom,
                endPoint: .top
            )
        )
    }
}
