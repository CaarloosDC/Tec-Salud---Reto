import Foundation
import MultipeerConnectivity
import os
import Combine

/// A class that handles the Multipeer Connectivity functionality for TecMedTransmiter.
@Observable
class TecMedMultiPeer: NSObject {
    let multiPeerQueue = DispatchQueue(label: "DC.Reto-Tec-Salud.multipeerQueue")
    
    private let serviceType = "TecMed-ML-Comm"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let session: MCSession
    private let log = Logger()
    
    var connectedPeers: [MCPeerID] = []
    var currentLabel: MLModelLabel? = nil
    var currentObjectData: ObjectInfo? = nil
    
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
        multiPeerQueue.async {
            self.connectedPeers = session.connectedPeers
        }
    }

    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let string = String(data: data, encoding: .utf8), let label = MLModelLabel(rawValue: string) {
            // Handle received string as label
            log.info("didReceive ML Model Label \(string)")
            multiPeerQueue.async {
                self.currentLabel = label
            }
        } else {
            // Attempt decoding the received data using a JSON decoder
            do {
                let decoder = JSONDecoder()
                let receivedData = try decoder.decode(ObjectInfo.self, from: data)
                
                if receivedData.coordinates != SIMD3<Float>.zero {
                    self.currentObjectData = receivedData
                }
                
//                // Handle received label and object info
//                // For example:
                print("==================================================")
                print("Recieved object coordinates: (x: \(receivedData.coordinates.x), y: \(receivedData.coordinates.y), z: (receivedData.coordinates.z))")
                print("Received distance from camera to object: \(receivedData.distance)")
                print("==================================================")
                
                print("==================================================")
                print("Current object coordinates: (x: \(currentObjectData?.coordinates.x ?? 0.0), y: \(currentObjectData?.coordinates.y ?? 0.0), z: (currentObjectData?.coordinates.z ?? 0.0))")
                print("Current distance from camera to object: \(currentObjectData?.distance ?? 0)")
                print("==================================================")
            } catch {
                log.error("Error decoding received data: \(error.localizedDescription)")
            }
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

// Object info struct
struct ObjectInfo: Codable,Equatable {
    var coordinates: SIMD3<Float>
    var distance: Float

    // Implement the Equatable protocol by providing an implementation for the == operator
    static func == (lhs: ObjectInfo, rhs: ObjectInfo) -> Bool {
        return lhs.coordinates == rhs.coordinates && lhs.distance == rhs.distance
    }
}
