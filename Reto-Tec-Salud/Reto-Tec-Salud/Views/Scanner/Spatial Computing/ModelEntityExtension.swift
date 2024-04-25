//
//  ModelEntityExtension.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/9/24.
//

import RealityKit

extension ModelEntity {
    class func createFingertip() -> ModelEntity {
        // Reference points that will be placed at the tip of our fingers for visual purposes
        let entity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [UnlitMaterial(color: .blue)], collisionShape: .generateSphere(radius: 0.005), mass: 0.0)
        
        entity.components.set(PhysicsBodyComponent(mode: .kinematic))
        entity.components.set(OpacityComponent(opacity: 1.0))
        
        return entity
    }
}
