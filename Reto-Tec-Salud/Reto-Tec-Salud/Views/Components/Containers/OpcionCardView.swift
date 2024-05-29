//
//  OpcionCardView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct OpcionCardView: View {
    
    var imageName: String
    var textString: String
    
    var body: some View {
        Button(action: {}) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: .infinity)
                
                Text(textString)
                    .font(.title)
            }
            .padding()
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 20))
    }
}

#Preview {
    OpcionCardView(imageName: "surgery", textString: "Procedimiento")
}
