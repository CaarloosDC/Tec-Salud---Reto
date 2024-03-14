//
//  BodyPartViewModel.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import Foundation

@Observable
final class BodyPartViewModel {
    var bodyParts: [BodyPart] = []
    
    init() {
        loadJSON(fileName: "bodyparts")
    }
    
    func loadJSON(fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let decoder = JSONDecoder()
            do {
                let data = try Data(contentsOf: url)
                bodyParts = try decoder.decode([BodyPart].self, from: data)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } else {
            print("\(fileName) wasn't found")
        }
    }
}
