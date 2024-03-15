//
//  SurgeryStepByStepView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct SurgeryStepByStepView: View {
    var surgicalProcedure: Procedure
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
