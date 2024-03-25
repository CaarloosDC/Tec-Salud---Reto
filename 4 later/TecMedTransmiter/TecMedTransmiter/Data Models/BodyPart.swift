//
//  BodyPart.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import Foundation


struct BodyPart: Identifiable, Codable {
    let id: MLModelLabel
    let medicalName, imageName, renderName: String
    let doableProcedures: [Procedure]
}

struct Procedure: Identifiable, Codable {
    let id: Int
    let surgeryTechnicalName, description: String
    let steps: [Step]
}

struct Step: Identifiable, Codable {
    let id: Int
    let description, imageName: String
}

/// An enumeration representing named body parts.
enum MLModelLabel: String, Codable, CaseIterable {
    case Arm, Ear, Eye, Knee
}
