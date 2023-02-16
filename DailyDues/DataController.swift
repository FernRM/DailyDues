//
//  DataController.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

import CoreData
import SwiftUI
import UserNotifications

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer


    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // _ was storeDescription
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }

            #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                self.deleteAll()
            }
            #endif
        }
    }

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    /// Create example DailyDues to make manual testing and previewing easier.
    ///  - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for dailyDuesCount in 1...7 {
            let dailyDue = DailyDue(context: viewContext)
            dailyDue.title = "Due numero \(dailyDuesCount)"
            dailyDue.creationDate = Date()
            dailyDue.isAMandPM = Bool.random()

            // check if AM and PM only - assign only 2, otherwise 1...5
            if dailyDue.isAMandPM {
                dailyDue.repetitionsPerDay = 2
            } else {
                dailyDue.repetitionsPerDay = Int16.random(in: 1...5)
            }
            // check repetitionsPerDay and assign random value within that
            dailyDue.repetitionsCompleted = Int16.random(in: 1...dailyDue.repetitionsPerDay)
            // check if completed or not based on randomly assigned values for repetitionsPerDay and repetitionsCompleted
            if dailyDue.repetitionsCompleted == dailyDue.repetitionsPerDay {
                dailyDue.isCompleted = true
            } else {
                dailyDue.isCompleted = false
            }
        }

        try viewContext.save()
    }

    /// Saves our Core Data context if there are changes. This silently
    /// ignores any errors caused by saving, but this should be fine with
    /// optional attributes.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    func deleteAll() {
        // find and delete all DailyDues
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DailyDue.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? container.viewContext.execute(batchDeleteRequest)
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        // parenthesis around the try? ensure the try container count is done first
        // if nothing comes back then it will nil coalesce to 0
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }

    func addReminders(for dailyDue: DailyDue, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotifications { success in
                    if success {
                        self.placeReminders(for: dailyDue, completion: completion)
                    } else {
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            case .authorized:
                self.placeReminders(for: dailyDue, completion: completion)
            default:
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    func removeReminders(for dailyDue: DailyDue) {
        let center = UNUserNotificationCenter.current()
        let id = dailyDue.objectID.uriRepresentation().absoluteString

        center.removePendingNotificationRequests(withIdentifiers: [id])
    }

    private func requestNotifications(completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            completion(granted)
        }
    }
    // only used when we know it's good to place reminders (after approval and checking notification access)
    private func placeReminders(for dailyDue: DailyDue, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = dailyDue.dailyDueTitle
        content.sound = .default

        let components = Calendar.current.dateComponents([.hour, .minute], from: dailyDue.reminderTime ?? Date())
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let id = dailyDue.objectID.uriRepresentation().absoluteString
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
}
