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
        NavigationSplitView {
            List(Procedure, selection: $selectedStep) { step in
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
                    .background(selectedStep == step ? Color.blue : Color.gray) // Change background color based on selection
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .frame(maxWidth: 260)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button style
            }
            .onChange(of: selectedStep) { oldValue, newValue in
                if let selectedBodyPart = newValue {
                    print("Selected body part: \(selectedStep.id)")
                }
            }
            .navigationTitle("Selecciona un Objeto")
            .navigationBarTitleDisplayMode(.automatic)
            // Ensure the title is always visible
            
        } detail: {
            if selectedStep != nil {
                Image(selectedStep?.imageName)
            }
            else {
                VStack {
                    PlaceHolderView(header: "Cirugia Virtual", fillerText: "Selecciona una parte del cuerpo para comenzar")
                    Spacer()
                }
            }
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
