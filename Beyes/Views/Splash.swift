//
//  Splash.swift
//  Beyes
//
//  Created by Alex Popa on 03/04/24.
//

import Foundation
import SwiftUI

struct Splash: View {
    @EnvironmentObject var router: Router
    @Environment(\.appEnvironment) var appEnvironment

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
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                appEnvironment.viewModels.authentication.$currentSession
                    .sink { session in
                        if let currentSession = session {
                            if currentSession {
                                router.setMain(.home)
                                print("Logged")

                            } else {
                                router.setMain(.login)
                            }
                        }
                    }
                    .store(in: &appEnvironment.viewModels.authentication.cancellables)
            }
        }
    }
}
