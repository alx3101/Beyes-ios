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

    var body: some View {
        VStack {
            Text("home")
            Button { router.setMain(.registration) } label: {
                Text("main")
            }
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
