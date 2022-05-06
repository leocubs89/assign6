//
//  assign6App.swift
//  assign6
//
//  Created by Leo Lopez and Dale Westberg on 5/4/22.
//

import SwiftUI

@main
struct assign6App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
