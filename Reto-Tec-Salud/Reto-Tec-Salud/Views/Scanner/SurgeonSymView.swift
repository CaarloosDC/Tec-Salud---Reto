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
    @Environment(TecMedMultiPeer.self) private var multiPeerSession

    @StateObject var model = SurgeonSymViewModel()
    @State var objectData: ObjectInfo = ObjectInfo(coordinates: SIMD3<Float>.zero, distance: 0.0)
    @State var sceneEntity: Entity?
    @State var realityContent: RealityViewContent?
    
    var body: some View {
        RealityView { content in
            // Content Entity
            do {
                content.add(model.setUpContentEntity())
                
                if model.pinPointEntity != nil {
                    print("excecuting")
                    let scene = try await Entity(named: "PinPoint", in: realityKitContentBundle)
                    self.sceneEntity = scene
                    content.add(self.sceneEntity!)
                    
                }
                else {
                    print("Entity is nil")
                }
                self.realityContent = content
            } catch {
                // Handle any potential errors
                print("Error adding content to RealityView: \(error)")
            }
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
                if (model.pinPointEntity == nil) {
                    await model.placeCube()
                }
                else {
                    await model.deletePinPoint()
                }
            }
        }))
        .onChange(of: multiPeerSession.currentObjectData) { oldValue, newValue in
            print("moving")
            updateScenePosition()
        }
    }
    
    private func updateScenePosition() {
        guard let sceneEntity = sceneEntity else { return }
        guard let pinPointEntity = model.pinPointEntity else { return }
        // Update scene position relative to the pinPointEntity using objectData.coordinates
        sceneEntity.setPosition(multiPeerSession.currentObjectData?.coordinates ?? SIMD3<Float>(0,0,0), relativeTo: pinPointEntity)
    }
}

#Preview {
    SurgeonSymView()
}
