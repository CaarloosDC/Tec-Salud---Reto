//
//  CameraView.swift
//  MLtest
//
//  Created by Sebastian Rosas Maciel on 3/5/24.
//

import SwiftUI

struct CameraView: View {
    @Environment(PredictionStatus.self) private var predictionStatus // Just migrated
    
    @State var multipeerSession = TecMedMultiPeer()
    @State var classifierViewModel = ClassifierViewModel()
    @State private var distance: Float = 0.0
    
    @State private var objectDetectionResults: ObjectDetectionResult = []
    
    var body: some View {
        let predictionLabel = predictionStatus.topLabel
        ZStack {
            // Use ARViewController instead of CameraViewControllerRepresentable
            ARViewController(distance: $distance, multiPeerSession: $multipeerSession, predictionStatus: predictionStatus) { classificationResults, label, confidence in
                predictionStatus.setClassificationResults(with: classificationResults, label: label, confidence: confidence)
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                DetectedBodyPartView(bodyPart: classifierViewModel.getPredictionData(label: predictionLabel), distance: $distance)
                    .transition(.slide)
            }
        }
        .onAppear {
            classifierViewModel.loadJSON()
        }
        .onChange(of: classifierViewModel.currentObject) { oldValue, newValue in
            let newBodyPart = classifierViewModel.getBodyPart(label: newValue)
            multipeerSession.send(label: newBodyPart.id)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
