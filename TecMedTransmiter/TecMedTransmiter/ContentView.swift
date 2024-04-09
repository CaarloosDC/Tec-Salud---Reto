//
//  ContentView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
 
    @State var isConnected = false
    let mcSession = MCSession(peer: MCPeerID(displayName: "Preview Peer"))
    let mcServiceType = "your-service-type-here"
    
    var body: some View {
        ZStack(alignment: .center) {
            CameraView()
            
            
//            VStack {
//                if !recieverSession.connectedPeers.isEmpty {
//                    DetectedDeviceView(deviceName: String(describing: recieverSession.connectedPeers.map(\.displayName)))
//                        .transition(.move(edge: .bottom))
//                }
//                
//                Spacer()
//            }
        }
    }
}

#Preview {
    ContentView()
}
