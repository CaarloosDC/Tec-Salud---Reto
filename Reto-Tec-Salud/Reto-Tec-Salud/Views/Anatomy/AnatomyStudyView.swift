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
        List(bodySystems.indices, id: \.self, selection: $selectedSystem) {system in
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
                .background(selectedSystem == bodySystems[system] ? Color.blue : Color.gray)
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
