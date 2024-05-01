//
//  Home.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.appEnvironment) var appEnvironment
    @EnvironmentObject var router: Router
    @State private var action: Loadable<Void> = .notRequested

    var body: some View {
        VStack {
            Text("home")
            Button { appEnvironment.interactors.auth.logout {
                action = $0
            } } label: {
                Text("login")
            }
            .onReceive(appEnvironment.interactors.auth.$currentSession, perform: { value in
                if !(value ?? false) {
                    router.setMain(.login)
                }

            })
//            Button("Logout") {
//                appEnvironment.viewModels.authentication.logout { completion in
//                    switch completion {
//                    case .success:
//                        router.setMain(.splash)
//                    case let .failure(failure):
//                        print(failure.localizedDescription)
//                    }
//                }
//            }
        }
    }
}

#Preview {
    HomeView()
}
