//
//  DetectedBodyPartView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct DetectedBodyPartView: View {
    private(set) var bodyPart: BodyPart
//    @Environment(TecMedMultiPeer.self) private var recieverSession
    
    var body: some View {
        VStack {
            Text("Detected Body Part")
                .font(.title)
                .bold()
                .padding()
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Common Name: ")
                        .font(.headline)
                        .foregroundStyle(.red)
                    + Text(bodyPart.id.rawValue)
                        .font(.footnote)
                    
                    Text("Medical Term ")
                        .font(.headline)
                        .foregroundStyle(.red)
                    + Text(bodyPart.medicalName)
                        .font(.footnote)
                }
                
                Spacer()
                
                Image(bodyPart.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150)
                    .shadow(radius: 10)
            }
            .padding()
        }
//        .onAppear{
//            recieverSession.send(label: bodyPart.id)
//        }
        .padding()
        .background(Color("light-dark"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
    }
}

#Preview {
    DetectedBodyPartView(bodyPart: BodyPart(id: .Arm, medicalName: "Brachium", imageName: "arm", renderName: "arm", doableProcedures: []))
}

