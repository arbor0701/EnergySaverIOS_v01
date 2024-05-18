//
//  EnergySaverIOS_v01App.swift
//  EnergySaverIOS_v01
//
//  Created by machine01 on 5/18/24.
//

import SwiftUI
import SwiftData

@main
struct EnergySaverIOS_v01App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
