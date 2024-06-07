//
//  ProcedimentStudyView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct ProcedimentStudyView: View {
    var body: some View {
        NavigationStack {
            VStack{
                Text("Elige el tipo de procedimiento").font(.extraLargeTitle)
                HStack{
                    NavigationLink {
                        MultiPeerView()
                    } label: {
                        VStack {
                            Image("surgery2")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity)
                            
                            Text("Procedimiento por escaneo")
                                .font(.title)
                        }
                        .padding()
                        .background(.white.opacity(0.3)) // Set your desired background color here
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // Ensure the background has the same corner radius
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    
                    NavigationLink {
                        SurgeryDetailView()
                            .clipShape(RoundedRectangle(cornerRadius: 40))
                            .ignoresSafeArea()
                    } label: {
                        VStack {
                            Image("hologram")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: .infinity)
                            
                            Text("Procedimiento virtual")
                                .font(.title)
                        }
                        .padding()
                        .background(.white.opacity(0.3)) // Set your desired background color here
                        .clipShape(RoundedRectangle(cornerRadius: 20)) // Ensure the background has the same corner radius
                    }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                }
            }.scaleEffect(0.95)
        }
    }
}

#Preview {
    ProcedimentStudyView()
}
