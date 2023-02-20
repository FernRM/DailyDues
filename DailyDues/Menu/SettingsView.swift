//
//  SettingsView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 2/20/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataController: DataController

    @StateObject var viewModel: ViewModel

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        Form {
                // TODO: Create list view of all DailyDues with design from "Edit:
            NavigationLink(destination: DailyDueEditListView(dailyDues: viewModel.dailyDues)) {
                Text("Daily Dues")
            }

            Button("Clear All Notification Reminders") {
                viewModel.deleteAllNotificationReminders()
            }

            Section {
                Button ("Reset All Daily Dues") {
                    // TODO: Decide exactly what this resets
                }
                Button ("Delete All Daily Dues") {
                    viewModel.deleteAllData()
                }
            }
            .accentColor(.red)
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dataController: .preview)
    }
}
