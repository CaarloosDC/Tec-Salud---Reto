//
//  ARSessionDelegateCoordinator.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/22/24.
//

import Foundation
import ARKit
import SwiftUI
import RealityKit

typealias ImageClassificationResult = [String: (basicValue: Double, displayValue: String)]
typealias ObjectDetectionResult = [(identifier: String, confidence: Float, boundingBox: CGRect, averageDistance: Float, objectCoordinates: SIMD3<Float>)]

class ARSessionDelegateCoordinator: NSObject, ARSessionDelegate {
    @Binding var distance: Float
    @Binding var multiPeerSession: TecMedMultiPeer
    
    var predictionStatus: PredictionStatus
    private var arView: ARView?
    
    // CoreML Models
    private var classifierModel: VNCoreMLModel?
    private var objectDetectionModel: VNCoreMLModel?
    
    // Closure for handling classification and object detection observations
    private var handleObservations: (ImageClassificationResult, String, String) -> ()
    
    // Frame Skipping Handling
    private var frameSkipCount = 0
    private let maxFrameSkip = 10
    
    init(distance: Binding<Float>, multiPeerSession: Binding<TecMedMultiPeer>, predictionStatus: PredictionStatus, classifierModel: VNCoreMLModel?, objectDetectionModel: VNCoreMLModel?, handleObservations: @escaping (ImageClassificationResult, String, String) -> ()) {
        _distance = distance
        _multiPeerSession = multiPeerSession
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
    
    func makeUIView(_ view: ARView) {
        self.arView = view  // Store the ARView reference passed from makeUIView
        view.session.delegate = self
        let config = ARWorldTrackingConfiguration()
        config.environmentTexturing = .automatic
        view.session.run(config)
    }
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.processCoreML(for: frame)
        }
        
        DispatchQueue.global().async {
            self.readLiDar(for: frame)
        }
    }
    
    // MARK: Handle CoreML Classification Results
    private func handleResults(classificationResults: [VNClassificationObservation], objectDetectionResults: [VNRecognizedObjectObservation], frame: ARFrame) {
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
        
        // Increment frame skip count and check if frame should be processed
        frameSkipCount += 1
        if frameSkipCount >= maxFrameSkip {
            // Process the frame
            self.handleObservations(compiledResults, classificationResults.first?.identifier ?? "Unknown", String(format: "%.0f%%", classificationResults.first?.confidence ?? 0.0))
            self.handleObjectDetectionResults(objectDetectionResults, for: frame)
            
            // Reset frame skip count
            frameSkipCount = 0
        }
    }

    private func handleObjectDetectionResults(_ results: [VNRecognizedObjectObservation], for frame: ARFrame) {
        // Handle object detection results
        var objectDetectionResults: ObjectDetectionResult = []
        
        guard let currentPointCloud = frame.rawFeaturePoints else {
            print("No point cloud available.")
            return
        }
        
        let cameraTransform = frame.camera.transform
        
        for result in results {
            let identifier = result.labels.first?.identifier ?? "Unknown"
            let confidence = result.labels.first?.confidence ?? 0.0
            let boundingBox = result.boundingBox
            
            // Bound box center coordinates
            let centerX = boundingBox.midX
            let centerY = boundingBox.midY
            
            // Convert center point coordinates to 3D coordinates
            let centerPoint = CGPoint(x: centerX, y: centerY)
            let raycastQuery = frame.raycastQuery(from: centerPoint, allowing: .estimatedPlane, alignment: .any)
            let raycastResults = arView?.session.raycast(raycastQuery).first
            let centerPoint3D = raycastResults?.worldTransform.columns.3
            
            // Calculcate the average distance of the points
            var totalDistance: Float = 0.0
            var pointCount: Float = 0.0
            
            for point in currentPointCloud.points {
                let pointInSpace = cameraTransform.inverse * SIMD4(point, 1)
                let distance2Camera = sqrt(pow(pointInSpace.x, 2) + pow(pointInSpace.y, 2) + pow(pointInSpace.z, 2))
                
                let convertedPoint = CGPoint(x: CGFloat(point.x) - boundingBox.origin.x, y: CGFloat(point.y) - boundingBox.origin.y)

                if boundingBox.contains(convertedPoint) {
                    totalDistance += distance2Camera
                    pointCount += 1.0
                }
            }
            
            let averageDistance = pointCount > 0 ? totalDistance / pointCount : 0.0
            let objectCoordinates = SIMD3<Float>(x: centerPoint3D?.x ?? 0.0, y: centerPoint3D?.y ?? 0.0, z: centerPoint3D?.z ?? 0.0)
            
            let objectInfo = ObjectInfo(coordinates: objectCoordinates, distance: averageDistance)
            multiPeerSession.sendObjectInfo(objectInfo: objectInfo)
            
            objectDetectionResults.append((identifier: identifier, confidence: confidence, boundingBox: boundingBox, averageDistance: averageDistance, objectCoordinates: objectCoordinates))
        }
        
        // You can handle the object detection results here, e.g., send them to another function or process them directly
    }
    
    // MARK: CoreML Processing
    private func processCoreML(for frame: ARFrame) {
        // CoreML Model Management
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
            self.handleResults(classificationResults: classificationResults, objectDetectionResults: objectDetectionResults, frame: frame)
        }
    }
    
    
    // MARK: LiDar Reading
    private func readLiDar(for frame: ARFrame) {
        guard let currentPointCloud = frame.rawFeaturePoints else { return }
        let cameraTransform = frame.camera.transform
        
        var closestDistance: Float = Float.greatestFiniteMagnitude
        
        for point in currentPointCloud.points {
            let pointInSpace = cameraTransform.inverse * SIMD4(point, 1)
            let distance2Camera = sqrt(pow(pointInSpace.x, 2) + pow(pointInSpace.y, 2) + pow(pointInSpace.z, 2))
            
            if (distance2Camera < closestDistance) {
                closestDistance = distance2Camera
            }
        }
        
        
        self.distance = closestDistance
    }
}



// Object info struct
struct ObjectInfo: Codable {
    let coordinates: SIMD3<Float>
    let distance: Float
}
