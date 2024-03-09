//
//  BodyPart.swift
//  MLtest
//
//  Created by Sebastian Rosas Maciel on 3/5/24.
//

import Foundation

struct BodyPart: Identifiable, Decodable {
    var technicalName, imageName, renderName, bodyPartDescription, labelName: String
    
    var doableProcedures: [Procedures]
    
    // Conforms to codable
    let id: String {
        return = labelName
    }
}

struct Procedures: Identifiable, Decodable {
    let id: Int
    
    var surgeryName, surgeryMedicName, procedureDescription: String
    var mockupSteps: String // will switch to a struct latter on
}
