//
//  DailyDueListView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

struct DailyDueListView: View {
    @EnvironmentObject var dataController: DataController

    @StateObject var viewModel: ViewModel

    @State public var showingDetailView = false
    @State private var showingAddView = false


    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {

                VStack( spacing: 0) {
                    ForEach(viewModel.dailyDues) { dailyDue in
                        DailyDueRowView(dailyDue: dailyDue, showDetailView: showingDetailView)
                    }
                    .padding([.horizontal, .bottom], 15)
                }

            }
            .background(.regularMaterial, ignoresSafeAreaEdges: .all)
            .navigationTitle("Daily Dues")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.deleteAllData()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.addSampleData()
                    } label: {
                        Image(systemName: "star")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {

                    Button {
                        withAnimation {
                            showingDetailView.toggle()
                        }
                        print("View toggled")
                    } label: {
                        Text("Edit")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // code
                        showingAddView.toggle()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                    .fullScreenCover(isPresented: $showingAddView) {
                        AddDailyDueView()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
        .navigationViewStyle(.stack)
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
