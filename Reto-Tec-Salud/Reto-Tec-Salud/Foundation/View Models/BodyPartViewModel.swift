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
        self.bodyParts = load("bodyparts.json")
    }
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data


        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }


        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }


        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func findBodyPart(label: String) -> BodyPart {
        return bodyParts.filter { $0.id.rawValue == label }.first ?? BodyPart(id: .Arm, medicalName: "Default value", imageName: "arm", renderName: "skeleton", doableProcedures: [])
    }

}
