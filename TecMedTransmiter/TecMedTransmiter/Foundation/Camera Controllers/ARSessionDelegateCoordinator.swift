//
//  ARSessionDelegateCoordinator.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/23/24.
//

import Foundation
import ARKit

typealias ImageClassificationResult = [String: (basicValue: Double, displayValue: String)]
typealias ObjectDetectionResult = [(identifier: String, confidence: Float, boundingBox: CGRect)]

class ARSessionDelegateCoordinator: NSObject, ARSessionDelegate {
    var predictionStatus: PredictionStatus
    let throttler = Throttler(queue: .global(qos: .userInteractive), minimumDelay: 5)
    // CoreML Models
    private var classifierModel: VNCoreMLModel?
    private var objectDetectionModel: VNCoreMLModel?
    
    private var handleObservations: (ImageClassificationResult, String, String) -> ()
    
    // Constructor
    init(predictionStatus: PredictionStatus, classifierModel: VNCoreMLModel?, objectDetectionModel: VNCoreMLModel?, handleObservations: @escaping (ImageClassificationResult, String, String) -> ()) {
        self.predictionStatus = predictionStatus
        self.classifierModel = classifierModel
        self.objectDetectionModel = objectDetectionModel
        self.handleObservations = handleObservations
        
        if classifierModel != nil {
            print("Classifier model initialized successfully")
        } else {
            print("Error: Failed to initialize classifier model")
        }
        if objectDetectionModel != nil {
            print("Object detection model initialized successfully")
        } else {
            print("Error: Failed to initialize object detection model")
        }
        
        super.init()
    }

    
    // Observation results handling
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
    
    private var frameSkipCount = 0
    private let maxFrameSkip = 10
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        
        guard let classifierModel = classifierModel, let objectDetectionModel = objectDetectionModel else { return }
        
        let requestGroup = DispatchGroup()
        
        var classificationResults: [VNClassificationObservation] = []
        var objectDetectionResults: [VNRecognizedObjectObservation] = []
        
        // Image Classification Request
        requestGroup.enter()
        let classificationRequest = VNCoreMLRequest(model: classifierModel) { request, error in
            defer { requestGroup.leave() }
            guard let results = request.results as? [VNClassificationObservation] else { return }
            classificationResults = results
        }
        classificationRequest.imageCropAndScaleOption = .centerCrop
        
        // Object Detection Request
        requestGroup.enter()
        let objectDetectionRequest = VNCoreMLRequest(model: objectDetectionModel) { request, error in
            defer { requestGroup.leave() }
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            objectDetectionResults = results
        }
        objectDetectionRequest.imageCropAndScaleOption = .centerCrop
        
        // Perform both requests
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? requestHandler.perform([classificationRequest, objectDetectionRequest])
        
        // Wait for both requests to complete
        requestGroup.notify(queue: .main) {
            // Increment frame skip count and check if frame should be processed
            self.frameSkipCount += 1
            if self.frameSkipCount >= self.maxFrameSkip {
                // Process the frame
                self.handleResults(classificationResults: classificationResults, objectDetectionResults: objectDetectionResults)
                
                // Reset frame skip count
                self.frameSkipCount = 0
            }
        }
    }
    
    private func handleResults(classificationResults: [VNClassificationObservation], objectDetectionResults: [VNRecognizedObjectObservation]) {
        // Handle classification results
        let predictionResultsMap = classificationResults.map {
            (
                $0.identifier,
                (basicValue: Double($0.confidence), displayValue: String(format: "%.0f%%", $0.confidence * 100))
            )
        }
        let compiledResults = Dictionary(uniqueKeysWithValues: predictionResultsMap)
        
        // Update PredictionStatus with classification results
        self.predictionStatus.setClassificationResults(with: compiledResults, label: classificationResults.first?.identifier ?? "Unknown", confidence: String(format: "%.0f%%", classificationResults.first?.confidence ?? 0.0))
        
        // Handle object detection results
        for result in objectDetectionResults {
            print("Detected object:")
            print("Bounding box: \(result.boundingBox)")
            print("Labels:")
            for label in result.labels {
                print("- Identifier: \(label.identifier), Confidence: \(label.confidence)")
            }
            print("==========")
        }
        
        // You can call any additional handling methods here
        // For example:
        // self.handleObservations(compiledResults, classificationResults.first?.identifier ?? "Unknown", String(format: "%.0f%%", classificationResults.first?.confidence ?? 0.0))
        // self.handleObjectDetectionResults(objectDetectionResults)
    }
    
}

