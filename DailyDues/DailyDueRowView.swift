//
//  DailyDueRowView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/23/23.
//

// TODO: Make ListView update correctly when updating repetitions

import SwiftUI

struct DailyDueRowView: View {
    @EnvironmentObject var dataController: DataController
    @StateObject var viewModel: ViewModel
    @ObservedObject var dailyDue: DailyDue
    @State private var icon: String
    var showingDetailView: Bool

    var body: some View {

        Group {
            if showingDetailView {
                VStack (alignment: .leading) {
                    NavigationLink(destination: EditDailyDueView(dailyDue: dailyDue)) {
                        HStack {
                            Text(dailyDue.dailyDueTitle)
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: "chevron.right.circle")
                                .font(.body)
                        }
                    }
                }
                .accentColor(.primary)

            } else {
                VStack (alignment: .leading) {
                    HStack {
                        Text(dailyDue.dailyDueTitle)
                            .font(.title3)
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(dailyDue.repetitionsCompleted) / \(dailyDue.repetitionsPerDay)")
                            .font(.body)
                    }

                    ProgressView(value: dailyDue.dailyDueCompletionAmount)
                        .accentColor(Color(dailyDue.dailyDueColor))
                        .background(Color(dailyDue.dailyDueColor).opacity(0.2))
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.addRepetition(dailyDue: dailyDue)
                    }
                }
            }
        }
        .accessibilityElement(children: .combine)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)





    }

    init(dailyDue: DailyDue, showDetailView: Bool) {
        let viewModel = ViewModel(dailyDue: dailyDue)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.dailyDue = dailyDue
        self.icon = viewModel.icon
        showingDetailView = showDetailView
    }
}

struct DailyDueRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueRowView(dailyDue: DailyDue.example, showDetailView: true)
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
