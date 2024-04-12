//
//  SurgeryDetailContentWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct SurgeryDetailContentWindow: View {
    @Environment(ProcedureViewModel.self) private var selectedProcedure
    @State private var currentStep = 0
    
    var body: some View {
        VStack {
            if let procedure = selectedProcedure.sentProcedure, procedure.steps.indices.contains(currentStep) {
                ScrollView {
                    Text(procedure.steps[currentStep].shortDescription)
                        .font(.title)
                        .padding()
                    
                    Text(procedure.steps[currentStep].description)
                        .multilineTextAlignment(.leading)
                    
                    Image(procedure.steps[currentStep].imageName)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
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
    }
}

#Preview {
    SurgeryDetailContentWindow()
}
