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
                RayCastViewController(predictionStatus: predictionStatus) { classificationResults, label, confidence in
                    predictionStatus.setClassificationResults(with: classificationResults, label: label, confidence: confidence)
                }
                   
                VStack {
                    Spacer()   
                    DetectedBodyPartView(bodyPart: classifierViewModel.getPredictionData(label: predictionLabel))
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

#Preview {
    CameraView()
}
