//
//  ContentView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CameraViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
