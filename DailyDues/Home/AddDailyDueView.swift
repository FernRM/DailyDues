//
//  EditDailyDueView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

struct AddDailyDueView: View {
    @EnvironmentObject var dataController: DataController
//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var icon: String = "circle"
    @State private var color: String = "Gray"
    @State private var repetitionsPerDay: Int = 1
    @State private var remindMe: Bool = false
    @State private var reminderTime: Date = Date()

    @State private var showingDeleteConfirm = false
    @State private var showingNotificationsError = false
    @FocusState private var titleInFocus: Bool

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    let iconColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {

        NavigationView {
            Form {
                Section(header: Text("Title").foregroundColor(Color(color))) {
                    TextField("Title", text: $title)
                        .focused($titleInFocus)
                }

                Section {
                    VStack {
                        Picker("Repetitions per day", selection: $repetitionsPerDay) {
                            ForEach(1...100, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                }

                Section(header: Text("Color").foregroundColor(Color(color))) {
                    LazyVGrid(columns: colorColumns) {
                        ForEach(DailyDue.colors, id: \.self, content: colorButton)
                    }
                }

                Section(header: Text("Daily Due Reminder").foregroundColor(Color(color))) {
                    Toggle("Show reminders", isOn: $remindMe.animation().onChange(checkNotificationPermissions))
                        .alert(isPresented: $showingNotificationsError) {
                            Alert(
                                title: Text("Ope!"),
                                message: Text("There was a problem! Please check if you have notifications enabled."),
                                primaryButton: .default(Text("Check Settings"), action: showAppSettings),
                                secondaryButton: .cancel()
                            )
                        }

                    if remindMe {
                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

//                Section(header: Text("Icon")) {
//                    LazyVGrid(columns: iconColumns) {
//                        ForEach(DailyDue.icons, id: \.self, content: iconButton)
//                    }
//                    .font(.title)
//                }
            }
            .navigationTitle("New Daily Due")
//            .onTapGesture {
//                titleInFocus = false
//            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        createNewDailyDue()
                        dataController.save()
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }



    }

    func checkNotificationPermissions() {

        if remindMe {
            dataController.checkSettings { success in
                if success == false {
                    showingNotificationsError = true
                    reminderTime = Date()
                    remindMe = false
                }
            }
        }
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
//            update()
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
//            update()
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

   func createNewDailyDue() -> Void {
        let newDailyDue = DailyDue(context: dataController.container.viewContext)

        newDailyDue.title = title
        newDailyDue.icon = icon
        newDailyDue.color = color
        newDailyDue.repetitionsPerDay = Int16(repetitionsPerDay)

       if remindMe {
           newDailyDue.reminderTime = reminderTime
           dataController.addReminders(for: newDailyDue) { _ in }
       } else {
           newDailyDue.reminderTime = nil
       }
    }
}

struct AddDailyDueView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        AddDailyDueView()
        // for swiftUI to read coredata values
            .environment(\.managedObjectContext, dataController.container.viewContext)
        // for own code to read coredata values, find, delete, read, etc.
            .environmentObject(dataController)
    }
}
