//
//  ObjectTracking.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/28/24.
//

import RealityKit
import ARKit
import QuartzCore
import simd
import SwiftUI
import Combine

// Will track the coordinates sent by iOS devices
@Observable
class TrackingComponent: Component {
    var referenceEntity: Entity? // Tracked entity
    var worldTrackingProvider: WorldTrackingProvider? // To retrieve device position data
    
    var currenCoordinates: SIMD3<Float>
    var isTracked: Bool // Does pinpoint currently exist?
    
    init(referenceEntity: Entity? = nil, worldTrackingProvider: WorldTrackingProvider? = nil, currenCoordinates: SIMD3<Float>, isTracked: Bool) {
        self.referenceEntity = referenceEntity
        self.worldTrackingProvider = worldTrackingProvider
        self.currenCoordinates = currenCoordinates
        self.isTracked = isTracked
        
        print("Current coordinates \(currenCoordinates) ")
    }
}

struct TrackingSystem: System {
    @Environment(TecMedMultiPeer.self) var multiPeersession
    
    static let entityQuery = EntityQuery(where: .has(TrackingComponent.self))
    public init(scene: RealityKit.Scene) { }
    
    // Obtain the scanned object's coordinates relative to the app's origin
    func triangulate(context: SceneUpdateContext, pinPointTransform: simd_float4x4, visionProTransform: simd_float4x4, recievedCoordinates: SIMD3<Float>) -> SIMD3<Float> {
        
        // PinPoint is considered as point B
        let inversePointB = pinPointTransform.inverse
        let pointCInGlobal =  SIMD4<Float>(recievedCoordinates.x, recievedCoordinates.y, recievedCoordinates.z, 1) * inversePointB
        let pointCInGlobal3D = SIMD3<Float>(pointCInGlobal.x, pointCInGlobal.y, pointCInGlobal.z)
        
        // Convert SIMD4 to simd_float4x4
        var matrixC = matrix_identity_float4x4
        matrixC.columns.3.x = pointCInGlobal3D.x
        matrixC.columns.3.y = pointCInGlobal3D.y
        matrixC.columns.3.z = pointCInGlobal3D.z
        
        return pointCInGlobal3D
    }
    
    func update(context: SceneUpdateContext) {
        for entity in context.entities(matching: Self.entityQuery, updatingSystemWhen: .rendering) {
            if var component: TrackingComponent = entity.components[TrackingComponent.self] {
                if component.referenceEntity == nil {
                    component.isTracked = false
                }
                else {
                    print("Updating object position...")
                    let currentVProTransform = component.worldTrackingProvider?.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())?.originFromAnchorTransform
                    print("Coordinates:\(component.currenCoordinates) ")
                    let pinPointTransform = component.referenceEntity?.transform.matrix
                    
                    // Change scaned object transform
                    entity.transform.translation = triangulate(context: context, pinPointTransform: pinPointTransform ?? matrix_identity_float4x4, visionProTransform: currentVProTransform ?? matrix_identity_float4x4, recievedCoordinates: multiPeersession.currentObjectData?.coordinates ?? SIMD3<Float>.zero)
                    
                    
                }
                
            }
        }
    }
}
