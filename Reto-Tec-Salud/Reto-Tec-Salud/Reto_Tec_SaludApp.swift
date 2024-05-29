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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
                .environment(volumeData)
                .environment(TecMedMultiPeer())
        }
        
        WindowGroup (id: "SecondWindow") {
            // will probably be used to store video data 
            SecondWindow()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
                .environment(TecMedMultiPeer())
                .ornament(attachmentAnchor: .scene(.trailing)) {
                    ChatBotOrnament()
                        .padding(12)
                }
        }
        
        // Surgery detail window for Scanner
        WindowGroup (id: "SurgeryDetailContentWindow") {
            ScannedSurgeryDetailContentWindow()
                .background(.white.opacity(0.5))
                .environment(selectedProcedure)
        }
        .defaultSize(CGSize(width: 500, height: 600))
        
        // Volumetric view for render vizualization in step by step surgery
        WindowGroup(id: "BodyPartVolume") {
            VolumeView()
                .environment(selectedProcedure)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.5, height: 0.6, depth: 0.5, in: .meters)
        
        // Immersive space for the skeleton model
        ImmersiveSpace(id: "skeletonImmersiveView") {
            SkeletonModelView()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        .immersiveContentBrightness(.bright)
        
        // Immersive Space for Object Tracking view (multipeer connectivity)
        ImmersiveSpace(id: "ObjectTrackingImmersiveSpace") {
            SurgeonSymView()
                .environment(TecMedMultiPeer())
        }
        
        ImmersiveSpace(id: "SurgeryImmersiveSpace") {
            SurgeryImmersiveView()
        }
        
    }
    
    // Entity
    init() {
        TrackingComponent.registerComponent()
        TrackingSystem.registerSystem()
    }
}


// Comentario de prueba
