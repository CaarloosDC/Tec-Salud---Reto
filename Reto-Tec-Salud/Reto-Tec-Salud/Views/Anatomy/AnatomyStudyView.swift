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
        NavigationStack {
            VStack{
                Text("¿Qué parte del cuerpo quieres explorar?").font(.extraLargeTitle)
                HStack {
                    List{
                        Text("Sistema circulatorio")
                        Text("Sistema respiratorio")
                        Text("Sistema nervioso")
                        Text("Sistema visual")
                        Text("Sistema esquelético")
                        Text("Sistema locomotor")
                        Text("Sistema auditivo")
                    }.bold()
                        .frame(width: 330)
                    
                    AnatomyDetailView()
                    Spacer()
                }
            }.scaleEffect(0.90)
        }
    }
    
    var mainContent: some View {
        List(bodySystems,id: , selection: $selectedSystem) {system in
            Button(action: {
                selectedSystem = system
            }) {
                HStack {
                    Text(system)
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                        .padding()
                    Spacer()
                }
                .background(selectedSystem == system ? Color.blue : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 260)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
    }
}


#Preview {
    AnatomyStudyView()
}
