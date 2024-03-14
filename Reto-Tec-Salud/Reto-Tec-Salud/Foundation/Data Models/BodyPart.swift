//
//  BodyPart.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import Foundation


struct BodyPart: Identifiable, Codable, Hashable {
    let id, medicalName, imageName, renderName: String
    let doableProcedures: [Procedure]
}

struct Procedure: Identifiable, Codable, Hashable {
    let id: Int
    let surgeryTechnicalName, description: String
    let steps: [Step]
}

struct Step: Identifiable, Codable, Hashable {
    let id: Int
    let description, imageName: String
}
