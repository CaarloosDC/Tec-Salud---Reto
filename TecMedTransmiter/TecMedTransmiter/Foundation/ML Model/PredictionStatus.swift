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

@Observable 
class PredictionStatus {
    var modelUrl = URL(fileURLWithPath: "")
    var modelObject = try! BodyPartClassifier_2(configuration: MLModelConfiguration())
    var topLabel = ""
    var topConfidence = ""
    var livePrediction: LivePredictionResults = (
        predictions: [:],
        topPrediction: "",
        topConfidence: "",
        boundingBox: CGRect.zero
    )

    func setLivePrediction(with predictions: [String: (basicValue: Double, displayValue: String)], topPrediction: String, topConfidence: String, boundingBox: BoundingBox) {
        self.livePrediction = (predictions: predictions, topPrediction: topPrediction, topConfidence: topConfidence, boundingBox: boundingBox)
        self.topLabel = topPrediction
        self.topConfidence = topConfidence
    }
}

