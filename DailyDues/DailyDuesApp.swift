//
//  DailyDuesApp.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

import SwiftUI

@main
struct DailyDuesApp: App {
    @StateObject var dataController: DataController

    init() {
        // make a new controller
        let dataController = DataController()
        // assign it to a property after wrapping it in a StateObject wrapper
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
            // for SwiftUI to read Core Data values
                .environment(\.managedObjectContext, dataController.container.viewContext)
            // for our own code to read Core Data values; find, delete, read, etc.
                .environmentObject(dataController)
            // look for willResignActive notification to save - app goes to background, multitasking, home screen, etc.
                .onReceive(
                    // Automatically save when we detect that we are no longer
                    // the foreground app. Use this rather than the scene phase
                    // API so we can port to macOS, where scene phase won't detect
                    // our app losing focus as of macOS 11.1
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
