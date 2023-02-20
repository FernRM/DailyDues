//
//  DailyDueEditListView.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 2/20/23.
//

import SwiftUI

struct DailyDueEditListView: View {

    var dailyDues: [DailyDue]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack( spacing: 0) {
                ForEach(dailyDues) { dailyDue in
                    DailyDueEditRowView(dailyDue: dailyDue)
                }
                .padding([.horizontal, .bottom], 15)
            }
            .navigationTitle("Edit Daily Dues")
        }
    }
}

struct DailyDueEditListView_Previews: PreviewProvider {
    static var previews: some View {
        DailyDueEditListView(dailyDues: [DailyDue.example, DailyDue.example, DailyDue.example])
    }
}
