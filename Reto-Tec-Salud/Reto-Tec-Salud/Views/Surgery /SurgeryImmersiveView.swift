//
//  SurgeryImmersiveView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/29/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SurgeryImmersiveView: View {
    @State var enlarge = false
    let attachmentId = "attachmentId"
    
    static var bodyPartEntity = Entity()

    var body: some View {
        RealityView { content, attachments in
            if let bodyPart = try? await Entity(named: "Arm", in: realityKitContentBundle) {
                
                SurgeryImmersiveView.bodyPartEntity = bodyPart
                print("Body part position: \(bodyPart.position)")
                content.add(bodyPart)
            }
            else {
                print("Unable to load Scene")
                return
            }

            // Adding scene attachments
            if let sceneAttachment = attachments.entity(for: attachmentId) {
                // Alter scene attachment position
                sceneAttachment.position = SIMD3<Float>(0.05,0,-0.2)
                sceneAttachment.transform.rotation = simd_quatf(angle: 0.5, axis: [0,1,0])
                print(sceneAttachment.position)
                content.add(sceneAttachment)
            }
            
        } update: { content, attachments  in
            if let scene = content.entities.first {
                let uniformScale: Float = enlarge ? 1.4 : 1.0
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        } attachments: {
            Attachment(id: attachmentId) {
                SimulatedSurgeryOrnament()
            }
        }.gesture(SpatialTapGesture()
            .targetedToAnyEntity()
            .onEnded({ _ in
                print("Tapped")
            })
        )
        .gesture(DragGesture()
            .targetedToEntity(SurgeryImmersiveView.bodyPartEntity)
            .onChanged({ value in
                SurgeryImmersiveView.bodyPartEntity.position = value.convert(value.location3D, from: .local, to: SurgeryImmersiveView.bodyPartEntity.parent!)
            })
        )
    }
}

#Preview {
    SurgeryImmersiveView()
}
