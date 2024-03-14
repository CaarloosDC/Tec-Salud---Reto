//
//  CameraView.swift
//  MLtest
//
//  Created by Sebastian Rosas Maciel on 3/5/24.
//

import SwiftUI

struct CameraView: View {
    @Environment(PredictionStatus.self) private var predictionStatus // Just migrated
    @State private var classifierViewModel = ClassifierViewModel() // Also migrated
    
    // State Vars
    @State private var startingOffset: CGFloat = UIScreen.main.bounds.height * 0.95
    @State private var currentOffset:CGFloat = 0
    @State private var endOffset:CGFloat = 0
    
    var body: some View {
        let predictionLabel = predictionStatus.topLabel
            ZStack{
                LiveCameraRepresentable() {
                    predictionStatus.setLivePrediction(with: $0, label: $1, confidence: $2)
                }
                
                DetectedBodyPartView(bodyPart: classifierViewModel.getPredictionData(label: predictionLabel))
                    .offset(y:startingOffset)
                    .offset(y:currentOffset)
                    .offset(y:endOffset)
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                withAnimation(.spring()){
                                    currentOffset = value.translation.height
                                }
                            }
                                
                            .onEnded{ value in
                                withAnimation(.spring()){
                                    if currentOffset < -150{
                                        endOffset = -startingOffset
                                    }else if endOffset != 0 && currentOffset > 150 {
                                        endOffset = .zero
                                    }
                                    currentOffset = 0
                                }
                            }
                    )
                    .scaleEffect(0.8)
            }
    }
}

#Preview {
    CameraView()
}
