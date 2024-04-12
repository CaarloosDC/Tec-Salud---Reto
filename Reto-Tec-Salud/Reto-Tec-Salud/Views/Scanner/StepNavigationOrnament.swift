//
//  StepNavigationOrnament.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct StepNavigationOrnament: View {
    var body: some View {
        HStack(alignment: .center) {
            // Left button, previous step
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.left")
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .padding()
            
            // Short step container
            ZStack {
                Text("Instructions go here")
                    .font(.footnote)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(minWidth:350,maxWidth: 350, maxHeight: 50)
            .padding(.horizontal, 10)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Right button, next step
            Button {
                
            } label: {
                Image(systemName: "arrowtriangle.right")
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .padding()
            
        }
        .glassBackgroundEffect()
        
    }
}

#Preview {
    StepNavigationOrnament()
}
