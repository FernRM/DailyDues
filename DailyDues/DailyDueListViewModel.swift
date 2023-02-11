//
//  DailyDueListViewModel.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import CoreData
import Foundation

extension DailyDueListView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        private let dailyDuesController: NSFetchedResultsController<DailyDue>
        @Published var dailyDues = [DailyDue]()

        init(dataController: DataController) {
            self.dataController = dataController

            let request: NSFetchRequest<DailyDue> = DailyDue.fetchRequest()
            let titleSortDescriptor = NSSortDescriptor(keyPath:\DailyDue.title, ascending: true)
            let isCompletedSortDescriptor = NSSortDescriptor(keyPath:\DailyDue.isCompleted, ascending: true)
            request.sortDescriptors = [isCompletedSortDescriptor, titleSortDescriptor]

            dailyDuesController = NSFetchedResultsController(
                fetchRequest: request,
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
                print("Failed to fetch the Daily Dues!")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newDailyDues = controller.fetchedObjects as? [DailyDue] {
                dailyDues = newDailyDues
            }
        }

        func deleteAllData() {
            dataController.objectWillChange.send()
            dataController.deleteAll()
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }
    }
}
