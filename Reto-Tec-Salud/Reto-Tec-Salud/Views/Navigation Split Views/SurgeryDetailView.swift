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
            .ornament(attachmentAnchor: .scene(.trailing)) {
                ChatBotOrnament()
                    .padding()
            }
    }
    
    var mainContent: some View {
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
                        .frame(maxWidth: .infinity, alignment: .leading) // Extiender el ancho al máximo
                        .contentShape(Rectangle()) // Hace que todo el espacio del botón sea interactivo
                        .background(selectedBodyPart == bodyParts.bodyParts[index] ? Color.blue : Color.clear) // Cambiar fondo si está seleccionado
                        .opacity(0.7)
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
