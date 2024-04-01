//
//  MultiPeerView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct MultiPeerView: View {
    @State var recieverSession = TecMedMultiPeer()
    @State var bodyPartsVM = BodyPartViewModel()
    @State var isConnected = false
    @State var retrievedBodyPart: BodyPart? = BodyPart(id: .Arm, medicalName: "Default value", imageName: "arm", renderName: "skeleton", doableProcedures: [])
    var body: some View {
        
        ZStack(alignment: .top) {
            DetectedDeviceView(deviceName: String(describing: recieverSession.connectedPeers.map(\.displayName)))
        
            BodyPartView(bodyPart: $retrievedBodyPart)
        }
        .onChange(of: recieverSession.currentLabel) { oldValue, newValue in
            retrievedBodyPart = bodyPartsVM.findBodyPart(label: newValue!.rawValue)
        }

    }
}

#Preview {
    MultiPeerView()
}
