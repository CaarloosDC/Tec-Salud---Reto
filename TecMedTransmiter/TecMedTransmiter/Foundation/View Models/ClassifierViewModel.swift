//
//  ClassifierViewModel.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/9/24.
//

import Foundation
import SwiftUI

@Observable 
final class ClassifierViewModel {
    var classifierData: [BodyPart] = [] // Published for SwiftUI updates
    var dataWhenAboutTapped: Int = 0
    private(set) var consecutivePredictions = 0
    private(set) var previousPrediction = ""
    private(set) var currentObject = ""

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
    
    func getBodyPart(label: String) -> BodyPart {
        return classifierData.filter { $0.id.rawValue == label }.first ?? BodyPart(id: .Arm, medicalName: "Default value", imageName: "arm")
    }

    func getPredictionData(label: String) -> BodyPart {
        if label == previousPrediction {
            consecutivePredictions += 1
        } else {
            consecutivePredictions = 0
            previousPrediction = label
        }
        
        if consecutivePredictions >= 35 {
            currentObject = label
            return classifierData.filter { $0.id.rawValue == label }.first ?? BodyPart(id: .Default, medicalName: "Default value", imageName: "arm")
        } else {
            return getBodyPart(label: currentObject)
        }
        // Inline if, if the first condition is true, it will return the first value, if not, it will return a default value
    }
}
