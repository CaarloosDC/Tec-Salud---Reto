//
//  ContentView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else {
                MainView()
                    .transition(.opacity)
            }
        }
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false) {_ in
                isLoading = false
            }
        }
        
    }
}


