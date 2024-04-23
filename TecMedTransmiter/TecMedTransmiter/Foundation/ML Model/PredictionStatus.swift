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
import UIKit
import SceneKit

@Observable 
class PredictionStatus {
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
    
    func handleObjectDetectionResults(_ results: [VNRecognizedObjectObservation]) {
        var objectDetectionResults: ObjectDetectionResult = []
        for result in results {
            let identifier = result.labels.first?.identifier ?? "Unknown"
            let confidence = result.labels.first?.confidence ?? 0.0
            let boundingBox = result.boundingBox
            
            objectDetectionResults.append((identifier: identifier, confidence: confidence, boundingBox: boundingBox))
        }
        
        // You can handle the object detection results here, e.g., send them to another function or process them directly
    }
    
    // Object Detection Model
}

extension CIImage {
    func resize(to size: CGSize) -> CIImage? {
        let scaleX = size.width / extent.size.width
        let scaleY = size.height / extent.size.height
        
        return transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
    }
}
