//
//  ContentView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var recieverSession = TecMedMultiPeer()
    @State var isConnected = false
    
    var body: some View {
        ZStack {
            CameraView()
            
            VStack {
                if !recieverSession.connectedPeers.isEmpty {
                    DetectedDeviceView(deviceName: String(describing: recieverSession.connectedPeers.map(\.displayName)))
                        .transition(.move(edge: .bottom))
                }
                
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
