//
//  Reto_Tec_SaludApp.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 29/02/24.
//

import SwiftUI

@main
struct Reto_Tec_SaludApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Immersive space for the skeleton model
        ImmersiveSpace(id: "skeletonImmersiveView") {
            SkeletonModelView()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        .immersiveContentBrightness(.bright)
    }
}
