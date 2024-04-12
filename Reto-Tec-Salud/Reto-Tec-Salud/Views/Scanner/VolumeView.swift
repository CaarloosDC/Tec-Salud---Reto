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
    @Environment(VolumeViewModel.self) private var volumeData
    
    var body: some View {
        Model3D(named: "Skeleton", bundle: realityKitContentBundle)
            .scaleEffect(0.3)
            .rotation3DEffect(Angle.degrees(volumeData.volumeRotationAngle), axis: .x)
            .rotation3DEffect(Angle.degrees(volumeData.volumeRotationAngle), axis: .y)
    }
}

#Preview {
    VolumeView()
}
