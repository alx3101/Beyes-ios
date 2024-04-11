//
//  BeyesApp.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI

@main
struct BeyesApp: App {
    @StateObject private var appEnvironment = AppEnvironment()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            RootView(rootNode: .splash)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
