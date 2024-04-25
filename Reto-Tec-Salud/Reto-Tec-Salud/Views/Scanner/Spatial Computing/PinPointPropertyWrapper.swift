//
//  PinPointPropertyWrapper.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import Foundation
import RealityKit
import RealityKitContent
import ARKit

@propertyWrapper
struct pinPoint {
    private var entity: ModelEntity?
    
    // Check if the entity already exists
    var wrappedValue: ModelEntity? {
        get { return entity }
        set {
            guard entity == nil else { return }
            entity = newValue
        }
    }
    
    init(wrappedValue: ModelEntity?) {
        self.wrappedValue = wrappedValue
    }
    
    mutating func deletePinPoint() {
        entity?.removeFromParent()
        entity = nil
    }
}
