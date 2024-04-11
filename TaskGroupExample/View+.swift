//
//  View+.swift
//  TaskGroupExample
//
//  Created by iOS신상우 on 4/9/24.
//

import SwiftUI

extension View {
    @ViewBuilder func isLoading(_ state: Bool) -> some View {
        self
            .disabled(state)
            .overlay {
                if state {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
}
