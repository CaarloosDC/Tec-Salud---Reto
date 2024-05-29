//
//  SurgeryDetailContentWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct ScannedSurgeryDetailContentWindow: View {
    @Environment(ProcedureViewModel.self) private var selectedProcedure
    @Environment(\.dismissImmersiveSpace) private var closeImmersiveSpace
    
    @State private var currentStep = 0
    
    var body: some View {
        VStack {
            Button {
                Task {
                    await closeImmersiveSpace()
                }
            } label: {
                Text("Close Immersive Space")
            }

            if let procedure = selectedProcedure.sentProcedure, procedure.steps.indices.contains(currentStep) {
                ScrollView {
                    Text(procedure.steps[currentStep].shortDescription)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text(procedure.steps[currentStep].description)
                        .multilineTextAlignment(.leading)
                    
                    Image(procedure.steps[currentStep].imageName)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
                        .padding()
                }
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
        }
        .ornament(attachmentAnchor: .scene(.bottom)) {
            StepNavigationOrnament(procedure: selectedProcedure.sentProcedure, currentStep: $currentStep)
        }
        .padding()
    }
}

#Preview {
    ScannedSurgeryDetailContentWindow()
}
