//
//  MenuView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack{
            Text("¿Qué deseas hacer el día de hoy?").font(.extraLargeTitle)
            HStack{
                NavigationLink {
                    ProcedimentStudyView()
                } label: {
                    OpcionCardView(ImageName: "surgery", TextString: "Estudiar un procedimiento").padding()
                }
                NavigationLink {
                    AnatomyStudyView()
                } label: {
                    OpcionCardView(ImageName: "anatomy", TextString: "Estudiar anatomía").padding()
                }
            }
        }.scaleEffect(0.95)
    }
}

#Preview {
    MenuView()
}
