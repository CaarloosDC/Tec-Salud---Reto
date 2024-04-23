//
//  ARSessionDelegateCoordinatorExtension.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/23/24.
//

import Foundation
import ARKit
import RealityKit
// Annotation handling as well as other necessary functions
extension ARSessionDelegateCoordinator {
    @MainActor func addAnnotation(rectBounds rect: CGRect) {
        print("Placing ")
        let point = CGPoint(x: rect.midX, y: rect.midY)
        
        // hit test equivalent
        guard let raycastQuery = arView?.makeRaycastQuery(from: point,
                                                        allowing: .existingPlaneInfinite,
                                                        alignment: .horizontal),
              let raycastResult = arView!.session.raycast(raycastQuery).first 
        else {
            if arView == nil {
                print("Error: arView is nil.")
            }

            return
        }
        
        let translation = raycastResult.worldTransform.columns.3
        let position = SIMD3<Float>(translation.x, translation.y, translation.z)
        print("Placing coordinates: x: \(position.x), y: \(position.y), z: \(position.z)")
        
        // Calculate distance between the camera and the object
        guard let cameraTransform = arView?.cameraTransform else { return }
        let distance = length(position - cameraTransform.translation)
        
        guard distance <= 0.5 else { return }
        
        let pinPoint = PinPoint(position: position)
        
        arView?.scene.addAnchor(pinPoint)
    }
    
    
}
