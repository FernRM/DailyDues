//
//  DailyDueRowViewModel.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

import Foundation

extension DailyDueRowView {
    class ViewModel: ObservableObject {
        let dailyDue: DailyDue

        // return correct icon string based on completion status
        var icon: String {
            if dailyDue.isCompleted {
                return "\(dailyDue.dailyDueIcon).fill"
            } else {
                return dailyDue.dailyDueIcon
            }
        }

        var label: String {
            if dailyDue.isCompleted {
                return "\(dailyDue.dailyDueTitle), completed"
            } else if dailyDue.repetitionsPerDay > 1 {
                return "\(dailyDue.dailyDueTitle) has been completed \(dailyDue.repetitionsCompleted) out of \(dailyDue.repetitionsPerDay) times"
            } else {
                return "\(dailyDue.dailyDueTitle) has not been completed"
            }
        }

        init(dailyDue: DailyDue) {
            self.dailyDue = dailyDue
        }

    }
}
