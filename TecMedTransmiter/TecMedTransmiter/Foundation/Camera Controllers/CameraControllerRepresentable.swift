//
//  CameraControllerRepresentable.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/24/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    var handleObservations: (LivePredictionResults) -> ()
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController(handleObservations: handleObservations)
        do {
            try vc.startCameraCaptureAndProcessing()
        } catch {
            print(error.localizedDescription)
        }
        return vc
    }
    
    func updateUIViewController(_ cameraViewController: CameraViewController, context: Context) {
    }
}
