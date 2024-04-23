import Foundation
import MultipeerConnectivity
import os

/// A class that handles the Multipeer Connectivity functionality for TecMedTransmiter.
@Observable
class TecMedMultiPeer: NSObject {
    private let serviceType = "TecMed-ML-Comm"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let log = Logger()
    
    var connectedPeers: [MCPeerID] = []
    var currentLabel: MLModelLabel? = nil
    var currentDistance: SIMD3<Float>? = nil
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .none)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        
        super.init()

        session.delegate = self
        serviceAdvertiser.delegate = self

        serviceAdvertiser.startAdvertisingPeer()
    }

    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
}

extension TecMedMultiPeer: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        log.error("ServiceAdvertiser didNotStartAdvertisingPeer: \(String(describing: error))")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        log.info("didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, session)
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
        // Extract label data
        let labelData = data.prefix(while: { $0 != 0 })
        guard let labelString = String(data: labelData, encoding: .utf8),
              let label = MLModelLabel(rawValue: labelString) else {
            log.info("didReceive invalid label data")
            return
        }

        // Extract coordinates data
        let coordinatesData = data.suffix(from: labelData.endIndex)
        let coordinates = SIMD3<Float>(from: coordinatesData)
        
        log.info("didReceive ML Model Label \(labelString) with coordinates \(coordinates)")
        
        DispatchQueue.main.async {
            // Update UI or perform actions with received label and coordinates
            self.currentLabel = label
            self.currentDistance = coordinates
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
