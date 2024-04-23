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
        SplitView(mainContent: mainContent, detailContent: BodyPartView(bodyPart: $selectedBodyPart, contentType: .bidimentional), placeHolder: PlaceHolderView(header: "cirugia virtual", fillerText: "Selecciona una parte del cuerpo para comenzar"), selectedItem: $selectedBodyPart)
    }
    
    var mainContent: some View {
        // Cambiamos de List a ScrollView y LazyVStack para una apariencia personalizada
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(bodyParts.bodyParts.indices, id: \.self) { index in
                    Button(action: {
                        selectedBodyPart = bodyParts.bodyParts[index]
                    }) {
                        HStack {
                            Text(bodyParts.bodyParts[index].id.rawValue)
                                .font(.title3)
                                .minimumScaleFactor(0.5)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Se extiende el ancho al máximo
                        .contentShape(Rectangle()) // Hace que todo el espacio del botón sea interactivo
                        .background(selectedBodyPart == bodyParts.bodyParts[index] ? Color.blue : Color.clear) // El fondo se vuelve transparente cuando no está seleccionado
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Se añade un divisor después de cada botón, excepto el último
                    if index < bodyParts.bodyParts.count - 1 {
                        Divider()
                    }
                }
            }
        }
    }

}



#Preview {
    SurgeryDetailView()
}
