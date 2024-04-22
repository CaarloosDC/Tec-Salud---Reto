//
//  MainView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI
import MultipeerConnectivity

struct MainView: View {
    @State private var multipeerSession = TecMedMultiPeer()
    @State private var classifierViewModel = ClassifierViewModel()
    @State private var isPresentingBrowser = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color("light-dark"))
                    .frame(maxHeight: 10)
                
                CameraView(multipeerSession: multipeerSession, classifierViewModel: classifierViewModel)
            }
            .navigationTitle("ML Test")
            .navigationBarItems(trailing: MultiPeerBrowserButton(isPresentingBrowser: $isPresentingBrowser, mcSession: multipeerSession.mcSession))
        }
    }
}

struct MultiPeerBrowserButton: View {
    @Binding var isPresentingBrowser: Bool
    let mcSession: MCSession
    var body: some View {
        Button(action: {
            isPresentingBrowser.toggle()
        }) {
            Image(systemName: "person.2.square.stack")
        }
        .sheet(isPresented: $isPresentingBrowser) {
            MultiPeerBrowserView(mcSession: mcSession)
        }
    }
}

#Preview {
    MainView()
}
