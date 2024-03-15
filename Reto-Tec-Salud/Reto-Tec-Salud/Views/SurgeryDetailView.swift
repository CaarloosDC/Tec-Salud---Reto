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
    @State var selectedBodyPart: BodyPart?
    
    var body: some View {
        NavigationView {
            List(selection: $selectedBodyPart) {
                ForEach(bodyParts.bodyParts) { bodyPart in
                    Text(bodyPart.id.rawValue)
                }
            }
            BodyPartView(bodyPart: $selectedBodyPart)
        }
    }
}

#Preview {
    SurgeryDetailView()
}
