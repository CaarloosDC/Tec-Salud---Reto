//
//  Reto_Tec_SaludApp.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 29/02/24.
//

import SwiftUI

@main
struct Reto_Tec_SaludApp: App {
    @State var selectedProcedure = ProcedureViewModel(sentProcedure: nil)
    @State var volumeData = VolumeViewModel(volumeRotationAngle: 0, sentRenderName: nil)
    // Temporary
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
                .environment(volumeData)
                .environment(TecMedMultiPeer())
        }
        
        WindowGroup (id: "SecondWindow") {
            SecondWindow()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
                .environment(TecMedMultiPeer())
        }
        
        // Surgery detail window for Scanner
        WindowGroup (id: "SurgeryDetailContentWindow") {
            SurgeryDetailContentWindow()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
                .environment(volumeData)
        }
        .defaultSize(CGSize(width: 500, height: 600))
        
        // Volumetric view for render vizualization (temporary, will eventually switch to an immersive space)
        WindowGroup(id: "BodyPartVolume") {
            VolumeView()
                .environment(volumeData)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 0.6, height: 0.6, depth: 0.3, in: .meters)
        
        // Immersive space for the skeleton model
        ImmersiveSpace(id: "skeletonImmersiveView") {
            SkeletonModelView()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        .immersiveContentBrightness(.bright)
    }
}


// Comentario de prueba
