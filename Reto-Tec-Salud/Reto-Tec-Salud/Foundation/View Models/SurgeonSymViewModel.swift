//
//  SurgeonSymViewModel.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/9/24.
//

/// May switch to protocol oriented programming later

import SwiftUI
import ARKit
import RealityKit
import RealityKitContent

@MainActor
class SurgeonSymViewModel: ObservableObject {
    private let session = ARKitSession()
    private let handTracking = HandTrackingProvider()
    private let sceneReconstruction = SceneReconstructionProvider()
    
    // Spacial recognition, needed for world anchor placement
    private let worldTracking = WorldTrackingProvider()
    
    private var contentEntity = Entity()
    
    private var meshEntities = [UUID: ModelEntity]()
    
    private let fingerEntities: [HandAnchor.Chirality: ModelEntity] = [
        .left: .createFingertip(),
        .right: .createFingertip()
    ]
    
    private var lastCubeplacementTime: TimeInterval = 0
    
    // Setting both finger tips as entities
    func setUpContentEntity() -> Entity {
        for entity in fingerEntities.values {
            contentEntity.addChild(entity)
        }
        
        return contentEntity
    }
    
    // Start scene reconstruction and handtracking services
    func runSession() async {
        do {
            try await session.run([sceneReconstruction, handTracking, worldTracking])
        } catch {
            print("Failed to start session : \(error)")
        }
    }
    
    // MARK: Hand updates handled here
    func processHandUpdates() async {
        // Iterate through the hand provider´s updates
        for await update in handTracking.anchorUpdates {
            let handAnchor = update.anchor
            
            guard handAnchor.isTracked else { continue }
            
            // Check if fingertip is tracked
            let fingerTip = handAnchor.handSkeleton?.joint(.indexFingerTip)
            
            guard ((fingerTip?.isTracked) != nil ) else {continue}
            
            let originFromWrist = handAnchor.originFromAnchorTransform // orientation and location of our hand
            let wristFromIndex = fingerTip?.anchorFromJointTransform // The position/orientation of the joint relative to the base joint of the skeleton
            let originFromindex = originFromWrist * wristFromIndex! // Using matrix multiplication
            
            // To correct finmgertip
            fingerEntities[handAnchor.chirality]?.setTransformMatrix(originFromindex, relativeTo: nil)
        }
    }
    
    // MARK: Scene reconstruction handled here
    func processReconstructionUpdates() async {
        for await update in sceneReconstruction.anchorUpdates {
            guard let shape = try? await ShapeResource.generateStaticMesh(from: update.anchor) else { continue }
            
            switch update.event {
            case .added:
                let entity = ModelEntity()
                entity.transform = Transform(matrix: update.anchor.originFromAnchorTransform)
                // Collision is essential
                entity.collision = CollisionComponent(shapes: [shape], isStatic: true)
                entity.physicsBody = PhysicsBodyComponent() // makes it possible to add physics to our model
                entity.components.set(InputTargetComponent())
                
                // Update mesh for scene reconstruction
                meshEntities[update.anchor.id] = entity
                
                contentEntity.addChild(entity)
            
            case .updated:
                guard let entity = meshEntities[update.anchor.id] else { fatalError("...")}
                entity.transform = Transform(matrix: update.anchor.originFromAnchorTransform)
                entity.collision?.shapes = [shape]
            
            case .removed:
                meshEntities[update.anchor.id]?.removeFromParent()
                meshEntities.removeValue(forKey: update.anchor.id)
            }
        }
    }
    
    // MARK: Handle world anchor uptates (AR Mapping and dot clouds)
    func processWorldUpdates() async {
        for await update in worldTracking.anchorUpdates {
            switch update.event {
            case .added, .updated:
                print("anchor position for \(update.anchor.id) updated to \(update.description)")
            case .removed:
                print("Anchor \(update.anchor.id) position now unknown")
            }
            
        }
    }
    
    // MARK: Entity placement
    func placeCube() async {
        guard let rightFingerPosition = fingerEntities[.right]?.transform.translation else { return }
        
        let placementLocation = rightFingerPosition + SIMD3<Float>(0,-0.05,0)
        
        let entity = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .systemBlue, isMetallic: false)], collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.1)), mass: 1)
        
        entity.setPosition(placementLocation, relativeTo: nil)
        
        // Get complete transform of the entity (position, rotation, scale) set value to matrix for it top comply with simd_float4x4
        let entityWorldTransform = entity.transform.matrix
        
        // Create world anchor
        let anchor = WorldAnchor(originFromAnchorTransform: entityWorldTransform)
        
        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.components.set(GroundingShadowComponent(castsShadow: true))
        
        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
        
        entity.components.set(PhysicsBodyComponent(shapes: entity.collision!.shapes, mass: 1.0, material: material, mode: .dynamic))
        
        contentEntity.addChild(entity)
    }
}
 
