//
//  ContentView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    @State private var showingDetailView = false

    var body: some View {
        DailyDueListView(dataController: dataController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
        // for swiftUI to read coredata values
            .environment(\.managedObjectContext, dataController.container.viewContext)
        // for own code to read coredata values, find, delete, read, etc.
            .environmentObject(dataController)
    }
}
