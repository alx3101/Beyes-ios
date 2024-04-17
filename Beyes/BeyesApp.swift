//
//  BeyesApp.swift
//  Beyes
//
//  Created by Alex Popa on 30/03/24.
//

import SwiftUI
import SwiftyBeaver

@main
struct BeyesApp: App {
    @StateObject private var appEnvironment = AppEnvironment()
    let persistenceController = PersistenceController.shared
    let logger = SwiftyBeaver.self

    init() {
        let console = ConsoleDestination()
        logger.addDestination(console)
    }

    var body: some Scene {
        WindowGroup {
            RouterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
