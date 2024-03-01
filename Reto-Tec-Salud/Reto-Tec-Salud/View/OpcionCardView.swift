//
//  OpcionCardView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI

struct OpcionCardView: View {
    
    var ImageName: String
    var TextString: String
    
    var body: some View {
        VStack{
            HStack {
                ZStack{
                    Rectangle().foregroundStyle(.gray).opacity(0.5).frame(width: 400, height: 400)
                    VStack{
                        Image(ImageName).resizable().scaledToFit().padding(.bottom, 35)
                        Text(TextString).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }.frame(width: 380, height: 380).cornerRadius(20)
            }
        }
    }
}

#Preview {
    OpcionCardView(ImageName: "surgery", TextString: "Procedimiento")
}
