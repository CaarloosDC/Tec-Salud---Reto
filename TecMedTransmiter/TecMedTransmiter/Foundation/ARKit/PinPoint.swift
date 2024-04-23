//
//  PinPoint.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/23/24.
//

import RealityKit

class PinPoint: Entity, HasAnchoring {
    static let name = String(describing: PinPoint.self)
    
    init(position: SIMD3<Float>) {
        super.init()
        
        
        Task {
            let loadedEntity = try Entity.load(named: "Location_pin")
            self.addChild(loadedEntity)
            loadedEntity.position = position
            loadedEntity.generateCollisionShapes(recursive: true)

        }
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
    
}
