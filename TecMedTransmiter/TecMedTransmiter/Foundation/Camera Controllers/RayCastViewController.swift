//
//  RayCastViewController.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/22/24.
//

import Foundation
import Vision
import SwiftUI
import UIKit
import Vision
import ARKit
import RealityKit

struct RayCastViewController: UIViewRepresentable {
    var predictionStatus: PredictionStatus
    private var classifierModel: VNCoreMLModel?
    private var objectDetectionModel: VNCoreMLModel?
    
    var handleObservations: (ImageClassificationResult, String, String) -> ()
 
    init(predictionStatus: PredictionStatus, handleObservations: @escaping (ImageClassificationResult, String, String) -> Void) {
        self.classifierModel = try? VNCoreMLModel(for: PredictionStatus().classifierModel.model)
        self.objectDetectionModel = try? VNCoreMLModel(for: PredictionStatus().objectDetectionModel.model)
        self.predictionStatus = predictionStatus
        self.handleObservations = handleObservations
    }
    
    func makeUIView(context: Context) -> some UIView {
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        
        arView.session.delegate = context.coordinator
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeCoordinator() -> ARSessionDelegateCoordinator {
        return ARSessionDelegateCoordinator(predictionStatus: predictionStatus, classifierModel: classifierModel, objectDetectionModel: objectDetectionModel, handleObservations: handleObservations )
    }
    
    // Other ARKit related code
   
}
