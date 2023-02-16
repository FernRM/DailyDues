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

    var body: some View {

            VStack (alignment: .leading) {

                HStack {
//                    Image(systemName: viewModel.icon)
//                    CircularProgressView(dailyDue: dailyDue)

                    Text(dailyDue.dailyDueTitle)
                        .font(.title2)
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
            .accessibilityElement(children: .combine)
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)

    }

    init(dailyDue: DailyDue) {
        let viewModel = ViewModel(dailyDue: dailyDue)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.dailyDue = dailyDue
        self.icon = viewModel.icon
    }
}

struct DailyDueRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueRowView(dailyDue: DailyDue.example)
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
