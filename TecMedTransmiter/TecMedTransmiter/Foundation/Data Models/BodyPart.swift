//
//  BodyPart.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import Foundation

struct BodyPart: Identifiable, Decodable, Equatable {
    var id: MLModelLabel
    var medicalName: String
    var imageName: String
    
    // Implement the == operator to compare two BodyPart instances for equality
    static func == (lhs: BodyPart, rhs: BodyPart) -> Bool {
        return lhs.id == rhs.id &&
               lhs.medicalName == rhs.medicalName &&
               lhs.imageName == rhs.imageName
    }
}

enum MLModelLabel: String, Decodable, CaseIterable, Hashable, Equatable {
    case Arm, Ear, Eye, Knee
}
