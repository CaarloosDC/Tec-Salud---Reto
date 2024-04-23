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
        /*Task {
            do {
                self.bodyParts = try await self.getBodyParts()
            } catch {
                print("Error fetching body parts: \(error)")
                // Handle the error as needed
            }
        }
         */
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
    
    // MARK:
    func getBodyParts() async throws -> [BodyPart] {
        let endPoint = "http://127.0.0.1:8000/getall"
        
        guard let url = URL(string: endPoint) else {
            throw APIError.invalidURL
        }
        // GET request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([BodyPart].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            throw APIError.invalidData
        }
    }
    
    func findBodyPart(label: String) -> BodyPart {
        return bodyParts.filter { $0.id.rawValue == label }.first ?? BodyPart(id: .Arm, medicalName: "Default value", imageName: "arm", renderName: "skeleton", doableProcedures: [])
    }

}


enum APIError: Error {
    case invalidURL, invalidResponse, invalidData
}
