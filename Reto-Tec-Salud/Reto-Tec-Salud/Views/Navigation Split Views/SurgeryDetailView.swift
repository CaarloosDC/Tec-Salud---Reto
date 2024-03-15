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
                Button(action: {
                    selectedBodyPart = bodyPart
                }) {
                    HStack {
                        Text(bodyPart.id.rawValue)
                            .font(.title3)
                            .minimumScaleFactor(0.5)
                            .padding()
                        Spacer()
                    }
                    .background(selectedBodyPart == bodyPart ? Color.blue : Color.gray) // Change background color based on selection
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 260)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button style
            }
            .onChange(of: selectedBodyPart) { oldValue, newValue in
                if let selectedBodyPart = newValue {
                    print("Selected body part: \(selectedBodyPart.id)")
                }
            }
            .navigationTitle("Selecciona un Objeto")
            .navigationBarTitleDisplayMode(.automatic)
            // Ensure the title is always visible
            
        } detail: {
            if selectedBodyPart != nil {
                BodyPartView(bodyPart: $selectedBodyPart)
            }
            else {
                VStack {
                    PlaceHolderView(header: "Cirugia Virtual", fillerText: "Selecciona una parte del cuerpo para comenzar")
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SurgeryDetailView()
}
