//
//  TecMedMultiPeer.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/25/24.
//

import Foundation
import MultipeerConnectivity
import os

/// A class that handles the Multipeer Connectivity functionality for TecMedTransmiter.
@Observable
class TecMedMultiPeer: NSObject {
    private let serviceType = "TecMed-ML-Comm"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser: MCNearbyServiceBrowser
    let mcSession: MCSession
    private let log = Logger()
    
    var connectedPeers: [MCPeerID] = []
    var currentLabel: MLModelLabel? = nil
    
    /// Sends the specified color to all connected peers.
    /// - Parameter color: The color to send.
    func send(label: MLModelLabel) {
        log.info("sendLabel: \(String(describing: label)) to \(self.mcSession.connectedPeers.count) peers")
        self.currentLabel = label

        if !mcSession.connectedPeers.isEmpty {
            do {
                try mcSession.send(label.rawValue.data(using: .utf8)!, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                log.error("Error for sending: \(String(describing: error))")
            }
        }
    }
    
    override init() {
        mcSession = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)

        super.init()

        mcSession.delegate = self
        serviceBrowser.delegate = self

        serviceBrowser.startBrowsingForPeers()
    }

    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }
}

extension TecMedMultiPeer: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        log.error("ServiceBrowser didNotStartBrowsingForPeers: \(String(describing: error))")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        log.info("ServiceBrowser found peer: \(peerID)")
        browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 10) // Invite a peer
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        log.info("ServiceBrowser lost peer: \(peerID)")
    }
}

extension TecMedMultiPeer: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        log.info("peer \(peerID) didChangeState: \(state.rawValue)")
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
    }

    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8), let label = MLModelLabel(rawValue: string) {
            log.info("didReceive ML Model Label \(string)")
            DispatchQueue.main.async {
                self.currentLabel = label
            }
        } else {
            log.info("didReceive invalid value \(data.count) bytes")
        }
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        log.error("Receiving streams is not supported")
    }

    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        log.error("Receiving resources is not supported")
    }

    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        log.error("Receiving resources is not supported")
    }
}
