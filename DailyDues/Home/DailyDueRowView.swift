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

    init(dailyDue: DailyDue) {
        let viewModel = ViewModel(dailyDue: dailyDue)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.dailyDue = dailyDue
        self.icon = viewModel.icon
    }

    var body: some View {
            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    Text(dailyDue.dailyDueTitle)
                        .font(.title3)
                        .fontWeight(.medium)
                    Spacer()

                    Text("\(dailyDue.repetitionsCompleted) / \(dailyDue.repetitionsPerDay)")
                        .font(.body)
                }
//                .padding(.bottom, 0)

                ProgressView(value: dailyDue.dailyDueCompletionAmount)
                    .accentColor(Color(dailyDue.dailyDueColor))
                    .background(Color(dailyDue.dailyDueColor).opacity(0.2))
//                    .padding(.top, 0)
            }
            .onTapGesture {
                withAnimation {
                    viewModel.addRepetition(dailyDue: dailyDue)
                }
            }
            .accessibilityElement(children: .combine)
            .padding()
            .background(Color(UIColor.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .primary.opacity(0.05), radius: 3, x: 5, y: 5)
    }
}

struct DailyDueRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueRowView(dailyDue: DailyDue.example)
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
