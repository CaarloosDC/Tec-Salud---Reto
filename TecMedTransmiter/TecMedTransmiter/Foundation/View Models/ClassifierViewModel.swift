//
//  ClassifierViewModel.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/9/24.
//

import Foundation
import SwiftUI

@Observable final class ClassifierViewModel {
    var classifierData: [Pokemon] = []
    var dataWhenAboutTapped:Int = 0
    
    init() {
        loadJSON()
    }
    func loadJSON() {
        print("loading...")
        if let url = Bundle.main.url(forResource: "pokemonData", withExtension: "json") {
            do {
                let jsonData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                classifierData = try decoder.decode([Pokemon].self, from: jsonData)
            } catch {
                print(error)
            }
        } else {
            print("could not find any data")
        }
    }
    
    func getPredictionData(label: String) -> Pokemon {
        // Inline if, if the first condition is true, it will return the first value, if not, it will return a default value
        return classifierData.filter { $0.name == label }.first ?? Pokemon(id: 11, name: "MissingNo.", imageName: "missing", type: "Unknown", description: "Unknown Pokemon")
    }
}

