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


    var body: some View {
        VStack (alignment: .leading) {
            Label {
                Text(dailyDue.dailyDueTitle)
            } icon: {
                Image(systemName: viewModel.icon)
                    .foregroundColor(Color(dailyDue.dailyDueColor))
            }

            ProgressView(value: dailyDue.dailyDueCompletionAmount)
                .accentColor(Color(dailyDue.dailyDueColor))
        }
        .onTapGesture {
            withAnimation {
                viewModel.addRepetition(dailyDue: dailyDue)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }

    init(dailyDue: DailyDue) {
        let viewModel = ViewModel(dailyDue: dailyDue)
        _viewModel = StateObject(wrappedValue: viewModel)

        self.dailyDue = dailyDue
    }
}

struct DailyDueRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueRowView(dailyDue: DailyDue.example)
            .previewLayout(.fixed(width: 400, height: 80))
    }
}
