//
//  MLConceptApp.swift
//  MLConcept
//
//  Created by Sebastian Rosas Maciel on 2/26/24.
//

import SwiftUI

@main
struct MLConceptApp: App {
    @StateObject private var predictionStatus = PredictionStatus()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(predictionStatus)
        }
    }
}
