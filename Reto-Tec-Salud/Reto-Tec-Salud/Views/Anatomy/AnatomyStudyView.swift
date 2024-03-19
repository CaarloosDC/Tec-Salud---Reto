//
//  AnatomyStudyView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct AnatomyStudyView: View {
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
}


#Preview {
    AnatomyStudyView()
}
