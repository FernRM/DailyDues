//
//  DailyDueEditRowView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 2/20/23.
//

import SwiftUI

struct DailyDueEditRowView: View {

    let dailyDue: DailyDue

    var body: some View {
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
        .foregroundColor(.primary)
        .accessibilityElement(children: .combine)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 5, y: 5)
    }
}

struct DailyDueEditRowView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueEditRowView(dailyDue: DailyDue.example)
    }
}
