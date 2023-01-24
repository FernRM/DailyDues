//
//  DailyDueListView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

struct DailyDueListView: View {

    @StateObject var viewModel: ViewModel
    @State private var showingDetailView = false


    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dailyDues) { dailyDue in
                    DailyDueRowView(dailyDue: dailyDue, showingDetailView: showingDetailView)
                }
            }
            .navigationTitle("Daily Dues")
        }
    }

    init(dataController: DataController) {
        let viewModel = ViewModel(dataController: dataController)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}


struct DailyDueListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueListView(dataController: DataController.preview)
    }
}
