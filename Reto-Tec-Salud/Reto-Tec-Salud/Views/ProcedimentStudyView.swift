//
//  ProcedimentStudyView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct ProcedimentStudyView: View {
    var body: some View {
        VStack{
            Text("Elige el tipo de procedimiento").font(.extraLargeTitle)
            HStack{
                NavigationLink {
                    MultiPeerView()
                } label: {
                    OpcionCardView(ImageName: "surgery2", TextString: "Procedimiento real").padding()
                }
                NavigationLink {
                    SurgeryDetailView()
                } label: {
                    OpcionCardView(ImageName: "hologram", TextString: "Procedimiento virtual").padding()
                }
            }
        }.scaleEffect(0.95)
    }
}

#Preview {
    ProcedimentStudyView()
}
