//
//  EnrouteApp.swift
//  Enroute
//
//  Created by oeng hokleng on 6/27/22.
//

import SwiftUI

@main
struct EnrouteApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
