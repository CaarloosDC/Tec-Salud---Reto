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
        SplitView(mainContent: mainContent, detailContent: BodyPartView(bodyPart: $selectedBodyPart), placeHolder: PlaceHolderView(header: "Cirugia Virtual", fillerText: "Selecciona una parte del cuerpo para comenzar"), selectedItem: $selectedBodyPart)
    }
    
    var mainContent: some View {
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
                .background(selectedBodyPart == bodyPart ? Color.blue : Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(maxWidth: 260)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .listStyle(.plain)
    }
}


#Preview {
    SurgeryDetailView()
}
