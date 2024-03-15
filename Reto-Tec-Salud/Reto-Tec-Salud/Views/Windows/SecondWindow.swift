//
//  SecondWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct SecondWindow: View {
    @Environment(ProcedureViewModel.self) private var selectedProcedure
    
    var body: some View {
        VStack {
            SurgeryStepByStepView(surgicalProcedure: selectedProcedure.sentProcedure ?? Procedure(id: 1, surgeryTechnicalName: "String", description: "String", steps: []))
        }
        .onAppear {
            print(selectedProcedure.sentProcedure?.surgeryTechnicalName ?? "Be afraid")
        }
    }
}
