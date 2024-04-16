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
            CameraViewControllerRepresentable() {
                predictionStatus.setLivePrediction(with: $0, label: $1, confidence: $2)
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
