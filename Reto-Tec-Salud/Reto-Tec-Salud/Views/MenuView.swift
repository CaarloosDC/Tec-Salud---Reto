//
//  MenuView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Text("¿Qué deseas hacer el día de hoy?").font(.extraLargeTitle)
                    .padding(.bottom, 20) // Added padding, cuz why not
                HStack{
                    Button(action: {
                        NavigationLink("Procedure") {
                            ProcedimentStudyView()
                        }

                    }) {
                        VStack {
                            Image("surgery")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity)
                            
                            Text("Estudiar un procedimiento")
                                .font(.title)
                        }
                        .padding()
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
    
                    NavigationLink {
                        AnatomyStudyView()
                    } label: {
                        OpcionCardView(imageName: "anatomy", textString: "Estudiar anatomía").padding()
                    }
                }
            }.scaleEffect(0.95)
        }
    }
}

#Preview {
    MenuView()
}
