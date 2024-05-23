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
    var sharedModelContainer:ModelContainer = {
        let schema = Schema([IotDevice.self])
        let modelConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: modelConfig)
            return container
        } catch {
            fatalError("Failed to create ModelContainer. Error: \(error)")
        }
        
        
    }()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }

    }
}
