//
//  ClassifierViewModel.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/9/24.
//

import Foundation
import SwiftUI

@Observable final class ClassifierViewModel {
    var classifierData: [BodyPart] = []
    var dataWhenAboutTapped:Int = 0
    
    init() {
        loadJSON()
    }
    func loadJSON() {
        print("loading...")
        if let url = Bundle.main.url(forResource: "bodyparts", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                classifierData = try decoder.decode([BodyPart].self, from: jsonData)
            } catch {
                print(error)
            }
        } else {
            print("Couldn´t find any data")
        }
    }
    
    func getPredictionData(label: String) -> BodyPart {
        // Inline if, if the first condition is true, it will return the first value, if not, it will return a default value
        return classifierData.filter { $0.medicalName == label }.first ?? BodyPart(id: .Arm, medicalName: "Unknown", imageName: "arm", renderName: "Unknown", doableProcedures: [])
    }
}

