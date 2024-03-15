//
//  SurgeryStepByStepView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct SurgeryStepByStepView: View {
    var surgicalProcedure: Procedure
    @State private var selectedStep: Step? = nil
    
    var body: some View {
        SplitView(mainContent: mainContent, detailContent: StepDetailView(), selectedItem: $selectedStep)
        }
        
        var mainContent: some View {
            List(surgicalProcedure.steps, selection: $selectedStep) { step in
                Button(action: {
                    selectedStep = step
                }) {
                    HStack {
                        Text("Paso No. \(step.id)")
                            .font(.title3)
                            .minimumScaleFactor(0.5)
                            .padding()
                        Spacer()
                    }
                    .background(selectedStep == step ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 260)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
}

#Preview {
    SurgeryStepByStepView(surgicalProcedure: Procedure(
        id: 1,
        surgeryTechnicalName: "Dummy Surgery",
        description: "This is a dummy procedure for testing purposes.",
        steps: [
            Step(id: 1, description: "Step 1", imageName: "step1"),
            Step(id: 2, description: "Step 2", imageName: "step2")
        ]
    )
    )
}
