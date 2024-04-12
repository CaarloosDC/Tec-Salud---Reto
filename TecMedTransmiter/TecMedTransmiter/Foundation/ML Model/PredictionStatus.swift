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
    
    // TODO - replace with the name of your classifier
    var modelObject = try! BodyPartClassifier_2(configuration: MLModelConfiguration())
    var topLabel = ""
    var topConfidence = ""
    
    // Live prediction results
    var livePrediction: LivePredictionResults = [:]
    
    func setLivePrediction(with results: LivePredictionResults, label: String, confidence: String) {
        livePrediction = results
        topLabel = label
        topConfidence = confidence
    
    }
}
