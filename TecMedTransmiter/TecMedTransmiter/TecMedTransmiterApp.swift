//
//  TecMedTransmiterApp.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import SwiftUI

@main
struct TecMedTransmiterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(PredictionStatus())
        }
    }
}
