//
//  Main.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

struct Main: View {
    let homeView = HomeView()
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Text(tabTitle("home")) }
        }
    }
}

private extension Main {
    func tabTitle(_ name: String) -> LocalizedStringKey {
        return LocalizedStringKey("tab.\(name)")
    }
}

#Preview {
    Main()
}
