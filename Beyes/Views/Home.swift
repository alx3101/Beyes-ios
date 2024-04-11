//
//  Home.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: Router

    var body: some View {
        VStack {
            Text("home")
        }.onAppear {
            router.setMain(.splash)
        }
    }
}

#Preview {
    HomeView()
}
