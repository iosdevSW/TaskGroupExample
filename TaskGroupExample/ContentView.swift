//
//  ContentView.swift
//  TaskGroupExample
//
//  Created by iOS신상우 on 4/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.text)
            Button {
//                viewModel.getData()
                viewModel.getDataWithThrow()
            } label: {
                Text("execute taskGroup")
            }
        }
        .isLoading(viewModel.isLoading)
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}
