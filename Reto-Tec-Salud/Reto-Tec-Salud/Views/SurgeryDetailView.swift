//
//  SurgeryDetailView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SurgeryDetailView: View {
    @State var bodyParts = BodyPartViewModel()
    @State private var selectedBodyPart: BodyPart? = nil
    
    var body: some View {
        NavigationSplitView {
            List(bodyParts.bodyParts, selection: $selectedBodyPart) { bodyPart in
                Button(bodyPart.id.rawValue) {
                    selectedBodyPart = bodyPart
                }
            }
            .onChange(of: selectedBodyPart) {oldValue, newValue in
                if let selectedBodyPart = newValue {
                    print("selected body part: \(selectedBodyPart.id)")
                }
            }
            .navigationTitle("¿Que Deseas Explorar?")
            
        } detail: {
            BodyPartView(bodyPart: $selectedBodyPart)
        }
    }
}

#Preview {
    SurgeryDetailView()
}
