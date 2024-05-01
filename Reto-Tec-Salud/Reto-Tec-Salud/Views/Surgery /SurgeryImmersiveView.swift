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
    
    var body: some View {
        RealityView { content in
            guard let bodyPart = try? await Entity(named: "Arm", in: realityKitContentBundle)
            else {
                print("Unable to load Scene")
                return
            }
            
            content.add(bodyPart)
        } update: { content in
            if let scene = content.entities.first {
                let uniformScale: Float = enlarge ? 1.4 : 1.0
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        }
    }
}

#Preview {
    SurgeryImmersiveView()
}
