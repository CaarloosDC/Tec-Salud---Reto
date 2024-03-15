//
//  MultiPeerView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct MultiPeerView: View {
    @State var recieverSession = TecMedMultiPeer()
    @State var isConnected = false
    var body: some View {
        
        ZStack {
            DetectedDeviceView(deviceName: String(describing: recieverSession.connectedPeers.map(\.displayName)[0]))
        }

    }
}

#Preview {
    MultiPeerView()
}
