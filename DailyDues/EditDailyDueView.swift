//
//  EditDailyDueView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

struct EditDailyDueView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var dailyDue: DailyDue

    @State private var title: String
    @State private var icon: String
    @State private var color: String
    @State private var repetitionsPerDay: Int
    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false

    @State private var remindMe: Bool
    @State private var reminderTime: Date

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    let iconColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(dailyDue: DailyDue) {
        self.dailyDue = dailyDue

        _title = State(wrappedValue: dailyDue.dailyDueTitle)
        _icon = State(wrappedValue: dailyDue.dailyDueIcon)
        _color = State(wrappedValue: dailyDue.dailyDueColor)
        _repetitionsPerDay = State(wrappedValue: Int(dailyDue.repetitionsPerDay))

        if let dailyDueReminderTime = dailyDue.reminderTime {
            _reminderTime = State(wrappedValue: dailyDueReminderTime)
            _remindMe = State(wrappedValue: true)
        } else {
            _reminderTime = State(wrappedValue: Date())
            _remindMe = State(wrappedValue: false)
        }

    }

    var body: some View {

        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title.onChange(update))
            }

            Section {
                VStack {
                    Picker("Repetitions per day", selection: $repetitionsPerDay.onChange(update)) {
                        ForEach(1...100, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
            } 

            Section(header: Text("Color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(DailyDue.colors, id: \.self, content: colorButton)
                }
            }

            Section(header: Text("Daily Due Reminder")) {
                Toggle("Show reminders", isOn: $remindMe.animation().onChange(update))
                    .alert(isPresented: $showingNotificationsError) {
                        Alert(
                            title: Text("Ope!"),
                            message: Text("There was a problem! Please check if you have notifications enabled."),
                            primaryButton: .default(Text("Check Settings")),
                            secondaryButton: .cancel()
                        )
                    }

                if remindMe {
                    DatePicker(
                        "Reminder time",
                        selection: $reminderTime.onChange(update),
                        displayedComponents: .hourAndMinute)
                }
            }

            Section(header: Text("Icon")) {
                LazyVGrid(columns: iconColumns) {
                    ForEach(DailyDue.icons, id: \.self, content: iconButton)
                }
                .font(.largeTitle)
            }

            Button("Delete Daily Due") {
                showingDeleteConfirm.toggle()
                dataController.delete(dailyDue)
            }
            .accentColor(.red)
            .alert(isPresented: $showingDeleteConfirm) {
                Alert(
                    title: Text("Delete Daily Due"),
                    message: Text("Are you sure you want to delete this?"),
                    primaryButton: .default(Text("Delete"), action: delete),
                    secondaryButton: .cancel()
                )
            }

        }
        .navigationTitle("Details")
        .onDisappear(perform: dataController.save)

    }

    func update() {
        dailyDue.title = title
        dailyDue.icon = icon
        dailyDue.color = color
        dailyDue.repetitionsPerDay = Int16(repetitionsPerDay)
        dailyDue.repetitionsCompleted = 0

        if remindMe {
            dailyDue.reminderTime = reminderTime

            dataController.addReminders(for: dailyDue) { success in
                if success == false {
                    showingNotificationsError = true
                    dailyDue.reminderTime = nil
                    remindMe = false
                }
            }
        } else {
            dailyDue.reminderTime = nil
            dataController.removeReminders(for: dailyDue)
        }
    }

    func delete() {
        dataController.delete(dailyDue)
        presentationMode.wrappedValue.dismiss()
    }

    func colorButton(for item: String) -> some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(Circle())

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func iconButton(for item: String) -> some View {

        Image(systemName: item)
            .foregroundColor(item == icon ? Color(color) : .primary)
            .padding(2)
            .onTapGesture {
            icon = item
            update()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == icon ? [.isButton, .isSelected] : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }

    func showAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

struct EditDailyDueView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        EditDailyDueView(dailyDue: DailyDue.example)
        // for swiftUI to read coredata values
            .environment(\.managedObjectContext, dataController.container.viewContext)
        // for own code to read coredata values, find, delete, read, etc.
            .environmentObject(dataController)
    }
}
