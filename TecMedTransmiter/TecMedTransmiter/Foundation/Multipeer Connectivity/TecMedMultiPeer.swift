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
    var currentDistance: SIMD3<Float>? = nil
    
    /// Sends the specified color to all connected peers.
    /// - Parameter color: The color to send.
    func send(label: MLModelLabel, coordinates: SIMD3<Float>) {
        log.info("sendLabel: \(String(describing: label)) to \(self.mcSession.connectedPeers.count) peers")
        self.currentLabel = label
        self.currentDistance = coordinates
        
        if !mcSession.connectedPeers.isEmpty {
            do {
                // Serialize coordinates into Data
                let coordinatesData = coordinates.toData()
                
                // Concatenate label data and coordinates data
                var combinedData = Data()
                combinedData.append(label.rawValue.data(using: .utf8)!)
                combinedData.append(coordinatesData)
                
                // Send combined data to peers
                try mcSession.send(combinedData, toPeers: mcSession.connectedPeers, with: .reliable)
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


extension SIMD3 where Scalar == Float {
    init(from data: Data) {
        var value: SIMD3<Float> = .zero
        data.withUnsafeBytes { ptr in
            guard ptr.count == MemoryLayout<Float>.size * 3 else { return }
            value.x = ptr.load(fromByteOffset: 0, as: Float.self)
            value.y = ptr.load(fromByteOffset: MemoryLayout<Float>.size, as: Float.self)
            value.z = ptr.load(fromByteOffset: MemoryLayout<Float>.size * 2, as: Float.self)
        }
        self = value
    }
    
    func toData() -> Data {
        var data = Data()
        withUnsafeBytes(of: self) { ptr in
            data.append(ptr.bindMemory(to: UInt8.self))
        }
        return data
    }
}

