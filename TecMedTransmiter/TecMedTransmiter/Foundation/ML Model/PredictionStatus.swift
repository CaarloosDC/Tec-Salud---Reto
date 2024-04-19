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
    var boundingBox: CGRect = CGRect.zero
    
    // Live prediction results
    var classificationResults: ImageClassificationResult = [:] // Empty dictionary
    var objectDetectionResults: ObjectDetectionResult = [] // Empty array of tuples
    
    // CoML Classification Model
    func setClassificationResults(with results: ImageClassificationResult, label: String, confidence: String) {
        classificationResults = results
        topLabel = label
        topConfidence = confidence
    }
    
    // Object Detection Model
    func setObjectDetectionResults(results: ObjectDetectionResult, boundingBox: CGRect){
        
    }
}
