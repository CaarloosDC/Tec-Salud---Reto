//
//  StepNavigationOrnament.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct StepNavigationOrnament: View {
    var procedure: Procedure?
    @Binding var currentStep: Int
    
    var body: some View {
        HStack(alignment: .center) {
            // Left button, previous step
            Button {
                if (currentStep > 0) {
                    currentStep -= 1
                }
            } label: {
                Image(systemName: "arrowtriangle.left")
            }
            .disabled(currentStep == 0)
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .padding()
            
            // Short step container
            ZStack {
                Text("Paso no. \(currentStep + 1)")
                    .font(.footnote)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .frame(minWidth:200,maxWidth: 200, maxHeight: 50)
            .padding(.horizontal, 10)
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Right button, next step
            Button {
                if let procedure = procedure, procedure.steps.count > currentStep + 1 {
                    currentStep += 1
                }
            } label: {
                Image(systemName: "arrowtriangle.right")
            }
            .disabled(procedure == nil || currentStep == (procedure?.steps.count)! - 1)
            .buttonStyle(.bordered)
            .buttonBorderShape(.circle)
            .padding()
            
        }
        .glassBackgroundEffect()
        
    }
}

#Preview {
    StepNavigationOrnament(procedure: Procedure(id: 1, surgeryTechnicalName: "Appendectomy", description: "This is a surgical procedure to remove the appendix.", steps: [
        Step(id: 1, description: "Make an incision in the lower right abdomen.", shortDescription: "Incision", imageName: "image1.png"),
        Step(id: 2, description: "Locate and remove the appendix.", shortDescription: "Remove Appendix", imageName: "image2.png"),
        Step(id: 3, description: "Close the incision with stitches or staples.", shortDescription: "Close Incision", imageName: "image3.png"),
    ]), currentStep: .constant(0))
}
