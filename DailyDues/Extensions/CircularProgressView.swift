//
//  CircularProgressView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 2/13/23.
//

import SwiftUI

struct CircularProgressView: View {
    @ObservedObject var dailyDue: DailyDue

    var body: some View {

        GeometryReader { geo in
            ZStack {
                Circle()
                    .stroke (
                        Color(dailyDue.dailyDueColor).opacity(0.5),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )

                Circle()
                    .trim(from: 0.0, to: dailyDue.dailyDueCompletionAmount)
                    .stroke (
                        Color(dailyDue.dailyDueColor),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut, value: dailyDue.dailyDueCompletionAmount)

            }
            .padding(15)
            
        }

    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(dailyDue: DailyDue.example)
    }
}
