//
//  AnatomyStudyView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct AnatomyStudyView: View {
    @State private var selectedSystem: String? = nil
    
    private var bodySystems = ["Sistema circulatorio", "Sistema respiratorio", "Sistema nervioso", "Sistema visual", "Sistema esqueletico", "Sistema locomotor", "Sistema auditivo"]
    
    var body: some View {
        
        SplitView(mainContent: mainContent, detailContent: AnatomyDetailView(), placeHolder: PlaceHolderView(header: "¿Qué sistema del cuerpo deseas explorar?", fillerText: "Lorem ipsum dolor sit amet bla, bla, bla"), selectedItem: $selectedSystem)
    }
    
    var mainContent: some View {
        // Usar ScrollView en lugar de List para permitir mayor personalización
        ScrollView {
            // Usar LazyVStack para comportamiento de lista perezosa con personalización
            LazyVStack(spacing: 0) { // spacing: 0 para que los divisores toquen los elementos
                ForEach(bodySystems.indices, id: \.self) { system in
                    Button(action: {
                        selectedSystem = bodySystems[system]
                    }) {
                        HStack {
                            Text(bodySystems[system])
                                .font(.title3)
                                .minimumScaleFactor(0.5)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Extender ancho al máximo
                        .contentShape(Rectangle()) // Hacer que todo el espacio sea "tocable"
                        .background(selectedSystem == bodySystems[system] ? Color.blue : Color.clear) // Cambiar fondo si está seleccionado
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Divisor
                    if system < bodySystems.count {
                        Divider()
                    }
                }
            }
        }
    }
}


#Preview {
    AnatomyStudyView()
}
