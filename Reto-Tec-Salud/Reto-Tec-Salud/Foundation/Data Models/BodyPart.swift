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


///Extending Structs so they are equatable, meanning they can be compared for equality
extension BodyPart: Equatable {
    static func == (lhs: BodyPart, rhs: BodyPart) -> Bool {
        return lhs.id == rhs.id &&
               lhs.medicalName == rhs.medicalName &&
               lhs.imageName == rhs.imageName &&
               lhs.renderName == rhs.renderName &&
               lhs.doableProcedures == rhs.doableProcedures
    }
}

extension Procedure: Equatable {
    static func == (lhs: Procedure, rhs: Procedure) -> Bool {
        return lhs.id == rhs.id &&
               lhs.surgeryTechnicalName == rhs.surgeryTechnicalName &&
               lhs.description == rhs.description &&
               lhs.steps == rhs.steps
    }
}

extension Step: Equatable {
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.id == rhs.id &&
               lhs.description == rhs.description &&
               lhs.imageName == rhs.imageName
    }
}

// Since MLModelLabel is an enum with a raw value of String, it automatically conforms to Equatable.

