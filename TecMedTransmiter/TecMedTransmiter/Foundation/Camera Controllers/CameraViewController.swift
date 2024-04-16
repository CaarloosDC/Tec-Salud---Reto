//
//  CameraViewController.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import Foundation

import UIKit
import SwiftUI
import AVFoundation
import Vision

typealias BoundingBox = CGRect
typealias LivePredictionResults = (predictions: [String: (basicValue: Double, displayValue: String)], topPrediction: String, topConfidence: String, boundingBox: BoundingBox)

struct ValuePerCategory {
    var category: String
    var value: Double
}

class CameraViewController: UIViewController {
    // ML Model Settings
    private var model: VNCoreMLModel?
    private var handleObservations: (LivePredictionResults) -> ()
    // Camera view settings
    private var permissionGranted = false // flag for camera use permission
    private var classifierViewModel = ClassifierViewModel()
    
    private let captureSession = AVCaptureSession()
    private let dataOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(
        label: "VideoOutput",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // used to determine view dimensions
    
    init(handleObservations: @escaping (LivePredictionResults) -> ()) {
        self.handleObservations = handleObservations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func startCameraCaptureAndProcessing() throws {
        guard permissionGranted else { return }
        self.model = try? VNCoreMLModel(for: PredictionStatus().modelObject.model)
        setupCaptureSession()
        
        sessionQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        check4Permission()
        
        do {
            try startCameraCaptureAndProcessing()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Handle device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIDevice.current.orientation
        switch orientation {
            // Home button on top
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoRotationAngle = 270
            // Home button on right
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoRotationAngle = 0
            // Home button on left
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoRotationAngle = 180
            // Home button at bottom
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoRotationAngle = 90
        default:
            self.previewLayer.connection?.videoRotationAngle = 90
        }
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    
    func check4Permission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
            
        case .notDetermined:
            requestPermission()
            
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        })
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(dataOutput) else { return }
        captureSession.addOutput(dataOutput)
        
        // Preview Layer settings
        screenRect = UIScreen.main.bounds // Fetches device data and sets frame dimensions according to said data
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fills the screen
        
        // SampleBuffer deledate must be added, extensions won't be triggered otherwise
        dataOutput.setSampleBufferDelegate(self, queue: sessionQueue)
        dataOutput.connection(with: .video)?.isEnabled = true // Always process the frames
        
        // Preview layer needs to be added into the main queue
        DispatchQueue.main.async { [weak self] in
            self!.previewLayer.frame = self!.view.bounds
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // adapted from https://www.letsbuildthatapp.com/course_video?id=1252
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        
        guard
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
            let model = model
            else {
                return
            }
            //let model2 = model2
        
        // process image and resize to scale with training image dimensions
        let cvImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        let ciimage = CIImage(cvImageBuffer: cvImageBuffer)
        let context = CIContext()
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        let uiImageResized = uiImage.scaleAndCropImage(uiImage, toSize: CGSize(width: Constants.imgDim, height: Constants.imgDim))
        let newCiImage = CIImage(image: uiImageResized)
        
        /// Debuging statement for Camera controler image capture
        //print("New frame captured and processing started")
        
        let request = VNCoreMLRequest(model: model) { request, error in
            if let error = error {
                print("Error during model inference: \(error.localizedDescription)")
                return
            }
            
            guard let results = request.results as? [VNRecognizedObjectObservation] else {
                print("Unable to get results from VNCoreMLRequest")
                return
            }
            
            var predictionResults: [String: (basicValue: Double, displayValue: String)] = [:]
            var topPrediction = ""
            var topConfidence = ""
            var boundingBox = CGRect.zero
            
            for result in results {
                let identifier = result.labels.first?.identifier ?? "Unknown"
                let confidence = result.labels.first?.confidence ?? 0.0
                
                let displayValue = String(format: "%.0f%%", confidence * 100)
                predictionResults[identifier] = (basicValue: Double(confidence), displayValue: displayValue)
                
                if confidence > (topConfidence as NSString).floatValue {
                    topPrediction = identifier
                    topConfidence = displayValue
                    boundingBox = result.boundingBox
                    
                    // Send bounding box information to ViewModel
                    self.classifierViewModel.updateBoundingBox(label: identifier, boundingBox: boundingBox)
                }
            }
            
            let livePredictionResultsWithBoundingBox = LivePredictionResults(
                predictions: predictionResults,
                topPrediction: topPrediction,
                topConfidence: topConfidence,
                boundingBox: boundingBox
            )
            
            DispatchQueue.main.async {
                self.handleObservations(livePredictionResultsWithBoundingBox)
            }
        }

        
        request.imageCropAndScaleOption = .centerCrop

        try? VNImageRequestHandler(
            ciImage: newCiImage!,
            orientation: exifOrientation(),
            options: [:]
        ).perform([request])
    }
}




