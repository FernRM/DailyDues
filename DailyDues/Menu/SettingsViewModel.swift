//
//  SettingsViewModel.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 2/20/23.
//

import CoreData
import Foundation

extension SettingsView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let dailyDuesController: NSFetchedResultsController<DailyDue>

        @Published var dailyDues = [DailyDue]()

        var dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            let dailyDueRequest: NSFetchRequest<DailyDue> = DailyDue.fetchRequest()
            let titleSortDescriptor = NSSortDescriptor(keyPath: \DailyDue.title, ascending: true)
            dailyDueRequest.sortDescriptors = [titleSortDescriptor]

            dailyDuesController = NSFetchedResultsController(
                fetchRequest: dailyDueRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            dailyDuesController.delegate = self

            do {
                try dailyDuesController.performFetch()
                dailyDues = dailyDuesController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch the Daily Dues for Settings!")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newDailyDues = controller.fetchedObjects as? [DailyDue] {
                dailyDues = newDailyDues
            }
        }

        func deleteAllNotificationReminders() {
            if !dailyDues.isEmpty {
                for dailyDue in dailyDues {
                    dataController.removeReminders(for: dailyDue)
                }
            }
        }

        // Deletes all data, including notifications
        func deleteAllData() {
            deleteAllNotificationReminders()
            dataController.objectWillChange.send()
            dataController.deleteAll()
        }

        // TODO: Remove when Settings are complete
        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
