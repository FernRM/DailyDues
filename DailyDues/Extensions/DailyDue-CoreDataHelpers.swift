//
//  DailyDue-CoreDataHelpers.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

import Foundation
import SwiftUI

extension DailyDue {
    static let colors = [
        "Gray",
        "Dark Gray",
        "Midnight",
        "Dark Blue",
        "Light Blue",
        "Teal",
        "Green",
        "Gold",
        "Orange",
        "Red",
        "Purple",
        "Pink"
    ]

    static let icons = [
        "circle",
        "star",
        "moon",
        "gamecontroller",
        "drop",
        "pill",
        "heart",
        "lightbulb",
        "figure.run.circle",
        "mountain.2",
        "lizard",
        "bird",
        "fish",
        "pawprint",
        "leaf",
        "square",
        "oval",
        "diamond"
    ]

    var dailyDueIsCompleted: Bool {
        if repetitionsCompleted == repetitionsPerDay {
            isCompleted = true
            return true
        } else {
            isCompleted = false
            return false
        }
    }

    var dailyDueTitle: String {
        title ?? NSLocalizedString("New Task", comment: "Create a new daily due")
    }

    var dailyDueCreationDate: Date {
        creationDate ?? Date()
    }

    var dailyDueColor: String {
        color ?? "Light Blue"
    }

    var dailyDueIcon: String {
        icon ?? "circle"
    }

    var dailyDueCompletionAmount: Double {
        return Double(repetitionsCompleted) / Double(repetitionsPerDay)
    }

    static var example: DailyDue {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let dailyDue = DailyDue(context: viewContext)
        dailyDue.title = "Drink full water bottle"
        dailyDue.repetitionsPerDay = 4
        dailyDue.repetitionsCompleted = 2
        dailyDue.isCompleted = false
        dailyDue.creationDate = Date() - 5

        return dailyDue
    }


}
