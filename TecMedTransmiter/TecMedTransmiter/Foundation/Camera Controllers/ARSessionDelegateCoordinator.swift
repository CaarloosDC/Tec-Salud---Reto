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
    private let maxFrameSkip = 4
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Delay execution by 5 seconds
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }

            // Saving current frame
            let pixelBuffer = frame.capturedImage

            if (pixelBuffer != nil) {
                print("Pixel buffer captured")
            } else {
                print("Failed to capture pixel buffer")
            }

            // Resizing image for detection ease
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let resizedCIImage = ciImage.resize(to: CGSize(width: Constants.imgDim, height: Constants.imgDim))

            // MARK: VN Model Request handling, image classification request
            let request = VNCoreMLRequest(model: self.classifierModel!) { request, error in
                if let error = error {
                    print("Error during model inference: \(error.localizedDescription)")
                }

                let observations = request.results as? [VNClassificationObservation] ?? []

                let predictionResultsMap = observations.map {
                    ($0.identifier,
                     (basicValue: Double($0.confidence), displayValue: String(format: "%.0f%%", $0.confidence * 100))
                    )
                }

                let topResult = observations.first
                let compiledResults = Dictionary(uniqueKeysWithValues: predictionResultsMap)

                // MARK: Object detection request
                let objectDetectionRequest = VNCoreMLRequest(model: self.objectDetectionModel!) { objectDetectionRequest, objectDetectionError in
                    if let objectDetectionError = objectDetectionError {
                        print("Error during object detection model inference: \(objectDetectionError.localizedDescription)")
                        return
                    }

                    let objectDetectionResults = objectDetectionRequest.results as? [VNRecognizedObjectObservation] ?? []

                    for result in objectDetectionResults {
                        print("Detected object:")
                        print("Bounding box: \(result.boundingBox)")
                        print("Labels:")
                        for label in result.labels {
                            print("- Identifier: \(label.identifier), Confidence: \(label.confidence)")
                        }
                        print("==========")
                    }
                    self.handleObservations(compiledResults, topResult!.identifier, String(format: "%.0f%%", topResult!.confidence * 100))

                    self.handleObjectDetectionResults(objectDetectionResults)
                }
                try? VNImageRequestHandler(ciImage: resizedCIImage!, options: [:]).perform([objectDetectionRequest])
            }
            request.imageCropAndScaleOption = .centerCrop

            try? VNImageRequestHandler(
                ciImage: resizedCIImage!,
                orientation: exifOrientation(),
                options: [:]
            )
            .perform([request])
        }
    }

}
