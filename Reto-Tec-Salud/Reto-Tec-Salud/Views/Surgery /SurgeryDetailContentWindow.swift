//
//  SurgeryDetailContentWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 5/29/24.
//

import SwiftUI

struct SurgeryDetailContentWindow: View {
    @Environment(ProcedureViewModel.self) private var selectedProcedure
    @Environment(\.dismissImmersiveSpace) private var closeImmersiveSpace
    
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
        } // Main VStack
    }
}

#Preview {
    SurgeryDetailContentWindow()
}
