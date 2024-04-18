//
//  PredictionStatus.swift
//  MLtest
//
//  Created by Sebastian Rosas Maciel on 3/5/24.
//

import Foundation
import SwiftUI
import Vision
import CoreML

@Observable class PredictionStatus {
    var modelUrl = URL(fileURLWithPath: "")
    
    // MARK: Image classifier
    var classifierModel = try! BodyPartClassifier(configuration: MLModelConfiguration())
    var topLabel = ""
    var topConfidence = ""
    
    // MARK: Object detection
    var objectDetectionModel = try! BodyPart_Finder(configuration: MLModelConfiguration())
    
    // Live prediction results
    var livePrediction: LivePredictionResults = [:]
    
    func setLivePrediction(with results: LivePredictionResults, label: String, confidence: String) {
        livePrediction = results
        topLabel = label
        topConfidence = confidence
    }
}
