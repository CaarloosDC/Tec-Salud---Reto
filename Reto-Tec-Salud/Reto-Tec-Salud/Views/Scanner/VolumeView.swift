//
//  VolumeView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/12/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct VolumeView: View {
    @State private var angle: Angle = .degrees(0)
    var body: some View {
        Model3D(named: "Skeleton", bundle: realityKitContentBundle)
            .scaleEffect(0.3)
            .rotation3DEffect(angle, axis: .x)
            .rotation3DEffect(angle, axis: .y)
    }
    
    func setRandomAngle() {
        angle = .degrees(Double.random(in: 1..<360))
    }
}

#Preview {
    VolumeView()
}
