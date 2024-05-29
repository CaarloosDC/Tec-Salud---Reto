//
//  SurgeryDetailContentWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 5/29/24.
//

import SwiftUI

struct SurgeryDetailContentWindow: View {
    @Environment(ProcedureViewModel.self) private var selectedProcedure
    @Environment(MediaViewModel.self) private var stepVideo
    @Environment(\.openWindow) private var openWindow
    
    @State private var currentStep = 0
    
    
    var body: some View {
        VStack { // First VStack, needed to align content
            VStack { // Second VStack, shows surgery steps
                if let procedure = selectedProcedure.sentProcedure, procedure.steps.indices.contains(currentStep) {
                    ScrollView {
                        
                        // Procedure name
                        ContainerView(contentType: .titleText, containerText: procedure.steps[currentStep].shortDescription, mediaName: nil)
                        
                        // Subtitle
                        ContainerView(contentType: .subtitleText, containerText: procedure.steps[currentStep].shortDescription, mediaName: nil)
                            .padding(.bottom, 10)
                        
                        // Instruction text
                        ContainerView(contentType: .paragraphText, containerText: procedure.steps[currentStep].description, mediaName: nil)
                        
                        // Step Image
                        ContainerView(contentType: .media, containerText: nil, mediaName: procedure.steps[currentStep].imageName)
                        
                        // Button to open video window
                        Button {
                            openWindow(id: "SecondWindow")
                        } label: {
                            ContainerView(contentType: .titleText, containerText: "Abrir Video Instructivo", mediaName: nil)
                        }
                        .buttonStyle(.plain)

                    }
                    .padding()
                }
                else {
                    VStack(alignment: .center) {
                        Text("No procedure data available")
                            .font(.extraLargeTitle2)
                            .bold()
                            .multilineTextAlignment(.center)
                            .minimumScaleFactor(0.7)
                            .padding()
                        
                        ProgressView()
                            .scaleEffect(2)
                            .padding()
                    }
                }
            } // Procedure container
            .padding()
            .frame(width: 500, height: 600)
            .background(.white.opacity(0.5))
            .glassBackgroundEffect()
                        
            // Speciffic ornament meant for attachments
            StepNavigationOrnament(procedure: selectedProcedure.sentProcedure, currentStep: $currentStep)
        }
        .onChange(of: currentStep) { oldValue, newValue in
            stepVideo.stepVideo = selectedProcedure.sentProcedure?.steps[currentStep].videoName ?? "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
        }// Main VStack
    }
}

#Preview {
    SurgeryDetailContentWindow()
}
