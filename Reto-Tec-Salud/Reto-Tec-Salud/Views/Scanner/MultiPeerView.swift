//
//  MultiPeerView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct MultiPeerView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State var recieverSession = TecMedMultiPeer()
    @State var bodyPartsVM = BodyPartViewModel()
    @State var isConnected = false
    @State private var isLoading = true
    @State var retrievedBodyPart: BodyPart? = BodyPart(id: .Arm, medicalName: "Default value", imageName: "arm", renderName: "skeleton", doableProcedures: [])
    
    
    var body: some View {
        
        VStack(alignment: .center) {
            HStack {
                let peerDisplayNames = recieverSession.connectedPeers.map { $0.displayName }
                
                ForEach(peerDisplayNames, id: \.self) { deviceName in
                    if (deviceName != "Apple Vision Pro") {
                        DetectedDeviceView(deviceName: deviceName)
                            .transition(.slide)
                    }
                }
            }
            
            if isLoading {
                Text("Cargando... Comienza a Escanear!")
                    .font(.extraLargeTitle)
                ProgressView()
                    .scaleEffect(1.3)
            } else {
                BodyPartView(bodyPart: $retrievedBodyPart, contentType: .threedimentional)
            }
            
        }
        .onAppear {
            // Gotta add a .default case into bodypart enum
            if (retrievedBodyPart?.medicalName == "Default value") {
                isLoading = true
            }
        }
        .onChange(of: recieverSession.currentLabel) { oldValue, newValue in
            if let label = newValue {
                retrievedBodyPart = bodyPartsVM.findBodyPart(label: label.rawValue)
                
                if (isLoading) {
                    isLoading.toggle()
                }
            }
        }
        
    }
}

#Preview {
    MultiPeerView()
}
