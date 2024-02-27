//
//  ContentView.swift
//  MLConcept
//
//  Created by Sebastian Rosas Maciel on 2/26/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CameraScanView(labelData: Classification())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
