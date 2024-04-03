//
//  ContentView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import SwiftUI

struct ContentView: View {
//    @Environment(TecMedMultiPeer.self) private var recieverSession
    @State var isConnected = false
    
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
