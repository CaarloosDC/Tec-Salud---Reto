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
            content.add(model.setUpContentEntity())
            
            // Adding Arm entity
            guard let entity = try? await Entity(named: "Arm", in: realityKitContentBundle) else {
                fatalError("Unable to load Entity")
            }
            
            self.trackedEntity = entity
            content.add(trackedEntity ?? entity)
            
            if let currentCoordinates = multiPeersession.currentObjectData?.coordinates {
                self.trackedEntity?.components.set(TrackingComponent(referenceEntity: model.pinPointEntity, worldTrackingProvider: model.worldTracking, currenCoordinates: currentCoordinates, isTracked: false))
            }
            
            // SetUp moving object
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
        }.gesture(SpatialTapGesture().targetedToAnyEntity().onEnded({ value in
            Task {
                if let currentCoordinates = multiPeersession.currentObjectData?.coordinates {
                    self.trackedEntity?.components.set(TrackingComponent(referenceEntity: model.pinPointEntity, worldTrackingProvider: model.worldTracking, currenCoordinates: currentCoordinates, isTracked: false))
                }
                
                // Pace a cube, change to pin point a world anchor instead
                if (model.pinPointEntity == nil) {
                    await model.placePin()
                }
                else {
                    print("Pinpoint already present in space")
                    return
                }
            }
        }))
    }
}

#Preview {
    SurgeonSymView()
}
