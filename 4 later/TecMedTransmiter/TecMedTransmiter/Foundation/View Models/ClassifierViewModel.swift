//
//  ClassifierViewModel.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/9/24.
//

import Foundation
import SwiftUI

@Observable final class ClassifierViewModel {
    var classifierData: [BodyPart] = [] // Published for SwiftUI updates
    var dataWhenAboutTapped: Int = 0

    init() {
        loadJSON()
    }

    func loadJSON() {
        print("loading...")
        guard let url = Bundle.main.url(forResource: "bodyparts", withExtension: "json") else {
            print("Couldn't find JSON file 'bodyparts.json' in your project's bundle.")
            return // Exit early if file not found
        }
        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            classifierData = try decoder.decode([BodyPart].self, from: jsonData)
            print("Successfully loaded JSON data.")
        } catch {
            print("Error loading JSON data: \(error.localizedDescription)")
        }
    }

    func getPredictionData(label: String) -> BodyPart {
        // Inline if, if the first condition is true, it will return the first value, if not, it will return a default value
        return classifierData.filter { $0.medicalName == label }.first ?? BodyPart(id: .Arm, medicalName: "Unknown", imageName: "arm", renderName: "Unknown", doableProcedures: [])
    }
}
