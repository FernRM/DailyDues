//
//  EditDailyDueView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

struct EditDailyDueView: View {
    @ObservedObject var dailyDue: DailyDue

    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String
    @State private var icon: String
    @State private var color: String
    @State private var repetitionsPerDay: Int
    @State private var showingDeleteConfirm = false

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    let iconColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

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
        }
        .navigationTitle("Details")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirm) {
            Alert(
                title: Text("Delete Daily Due"),
                message: Text("Are you sure you want to delete this?"),
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel()
            )
        }
    }

    init(dailyDue: DailyDue) {
        self.dailyDue = dailyDue

        _title = State(wrappedValue: dailyDue.dailyDueTitle)
        _icon = State(wrappedValue: dailyDue.dailyDueIcon)
        _color = State(wrappedValue: dailyDue.dailyDueColor)
        _repetitionsPerDay = State(wrappedValue: Int(dailyDue.repetitionsPerDay))
    }

    func update() {
        dailyDue.title = title
        dailyDue.icon = icon
        dailyDue.color = color
        dailyDue.repetitionsPerDay = Int16(repetitionsPerDay)
        dailyDue.repetitionsCompleted = 0
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
