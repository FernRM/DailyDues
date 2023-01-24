//
//  Binding-OnChange.swift
//  DailyDues
//
//  Created by Ricardo Fernandez on 1/24/23.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
