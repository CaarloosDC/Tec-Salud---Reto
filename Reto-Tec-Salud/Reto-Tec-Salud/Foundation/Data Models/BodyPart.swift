//
//  BodyPart.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import Foundation

struct BodyPart: Identifiable, Codable, Hashable {
    let id: MLModelLabel
    let medicalName, imageName, renderName: String
    let doableProcedures: [Procedure]
}

struct Procedure: Identifiable, Codable, Hashable {
    let id: Int
    let surgeryTechnicalName, description: String
    let steps: [Step]
}

struct Step: Identifiable, Codable, Hashable {
    let id: Int
    let description, shortDescription, imageName: String
}

enum MLModelLabel: String, Codable, CaseIterable, Hashable {
    case Arm, Ear, Eye, Knee
}
