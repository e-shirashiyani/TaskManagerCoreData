//
//  TaskManagmentCoreDateApp.swift
//  TaskManagmentCoreDate
//
//  Created by e.shirashiyani on 2/4/22.
//

import SwiftUI

@main
struct TaskManagmentCoreDateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
