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
    @State var classifierViewModel = ClassifierViewModel() // Also migrated
    
    var body: some View {
        let predictionLabel = predictionStatus.topLabel
        ZStack{
            CameraViewControllerRepresentable() { predictions, topPrediction, topConfidence, boundingBox in
                predictionStatus.setLivePrediction(with: predictions, topPrediction: topPrediction, topConfidence: topConfidence, boundingBox: boundingBox)
            }
            .ignoresSafeArea()
            
            DetectedBodyPartView(bodyPart: classifierViewModel.getPredictionData(label: predictionLabel))
            
            Rectangle()
                .stroke(Color.red, lineWidth: 2)
                .frame(width: classifierViewModel.getBoundingBox(label: predictionLabel)?.width, height: classifierViewModel.getBoundingBox(label: predictionLabel)?.height)
                .position(x: classifierViewModel.getBoundingBox(label: predictionLabel)?.midX ?? 0.0, y: classifierViewModel.getBoundingBox(label: predictionLabel)?.midY ?? 0.0)
        }
        .onAppear {
            classifierViewModel.loadJSON()
        }
        .onChange(of: classifierViewModel.currentObject) { oldValue, newValue in
            var newBodyPart = classifierViewModel.getBodyPart(label: newValue)
            multipeerSession.send(label: newBodyPart.id)
        }
    }
}

#Preview {
    CameraView()
}
