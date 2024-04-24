//
//  CameraControlerLiDarExtension.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/22/24.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit

struct ARViewController: UIViewRepresentable {
    @Binding var distance: Float
    @Binding var multiPeerSession: TecMedMultiPeer
    var predictionStatus: PredictionStatus
    
    private var classifierModel: VNCoreMLModel?
    private var objectDetectionModel: VNCoreMLModel?
    private var handleObservations: (ImageClassificationResult, String, String) -> ()
    
    init(distance: Binding<Float>, multiPeerSession: Binding<TecMedMultiPeer>, predictionStatus: PredictionStatus, handleObservations: @escaping (ImageClassificationResult, String, String) -> ()) {
        _distance = distance
        _multiPeerSession = multiPeerSession
        self.classifierModel = try? VNCoreMLModel(for: PredictionStatus().classifierModel.model)
        self.objectDetectionModel = try? VNCoreMLModel(for: PredictionStatus().objectDetectionModel.model)
        self.predictionStatus = predictionStatus
        self.handleObservations = handleObservations
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        
        arView.session.delegate = context.coordinator
        context.coordinator.makeUIView(arView)
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Update UI if needed
    }
    
    func makeCoordinator() -> ARSessionDelegateCoordinator {
        return ARSessionDelegateCoordinator(distance: $distance, multiPeerSession: $multiPeerSession,  predictionStatus: predictionStatus, classifierModel: classifierModel, objectDetectionModel: objectDetectionModel, handleObservations: handleObservations)
    }
}


