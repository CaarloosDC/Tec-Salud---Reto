//
//  MultiPeerBrowserView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/8/24.
//

import Foundation
import SwiftUI
import MultipeerConnectivity

struct MultiPeerBrowserView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MCBrowserViewController
    
    let mcSession: MCSession
    private let mcServiceType = "TecMed-ML-Comm"
    
    func makeUIViewController(context: Context) -> MCBrowserViewController {
        let mcBrowser = MCBrowserViewController(serviceType: mcServiceType, session: mcSession)
        mcBrowser.delegate = context.coordinator
        return mcBrowser
    }
    
    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
        // Update the view controller if needed
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MCBrowserViewControllerDelegate {
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            // Handle when the browser finishes
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            // Handle when the browser is cancelled
        }
    }
}

struct MultiPeerBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        let mcSession = MCSession(peer: MCPeerID(displayName: "Preview Peer"))
        let mcServiceType = "TecMed-ML-Comm"
        
        var body: some View {
            MultiPeerBrowserView(mcSession: mcSession)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
