//
//  SimulatedSurgeryOrnament.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 5/27/24.
//

import SwiftUI

struct SimulatedSurgeryOrnament: View {
    @State private var isViewVisible = true
    
    var body: some View {
        HStack {
            if isViewVisible {
                SurgeryDetailContentWindow()
            } else {
                // View must always be in the same position, placing a clear rectangle should leave the button in the same position
                Rectangle()
                    .padding()
                    .frame(width: 500, height: 600)
                    .foregroundStyle(Color.clear)
                    
            }
            
            HStack {
                Toggle(isOn: $isViewVisible) {
                    Label("Pasos", systemImage: "questionmark.circle.fill")
                }
                .help("Pasos")
                .toggleStyle(.button)
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
                .glassBackgroundEffect(in: .circle)
            }
            .padding(.trailing)
            
            Spacer()
        }
    }
}

#Preview {
    SimulatedSurgeryOrnament()
}
