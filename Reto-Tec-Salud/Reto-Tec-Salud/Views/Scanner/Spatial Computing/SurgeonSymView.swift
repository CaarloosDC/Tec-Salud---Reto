//
//  SurgeonSymView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/9/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SurgeonSymView: View {
    @StateObject var model = SurgeonSymViewModel()
    @State private var trackedEntity: Entity?
    @Environment(TecMedMultiPeer.self) var multiPeersession
    
    var body: some View {
        RealityView { content in
            // Content Entity
            trackedEntity = model.trackedEntity
            trackedEntity?.setPosition(multiPeersession.currentObjectData?.coordinates ?? SIMD3<Float>(0,0,0), relativeTo: model.pinPointEntity)
            content.add(model.setUpContentEntity())
        }.task {
            // Run ARKit Session
            await model.runSession()
        }
        .task {
            // Process Hand Updates
            await model.processHandUpdates()
        }.task {
            // Process world reconstruction
            await model.processReconstructionUpdates()
        }.task {
            // Process world processing and anchor placement
            await model.processWorldUpdates()
        }.task {
            await model.processObjectTrackingUpdates(objectPosition: multiPeersession.currentObjectData?.coordinates ?? SIMD3<Float>.zero, trackedEntity: trackedEntity)
        }.gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            Task {
                // Pace a cube, change to pin point a world anchor instead
                if (model.pinPointEntity == nil) {
                    await model.placeCube()
                }
                else {
                    await model.deletePinPoint()
                }
            }
        }))
    }
}

#Preview {
    SurgeonSymView()
}
