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
        SplitView(mainContent: mainContent, detailContent: StepDetailView(stepNo: selectedStep ?? Step(id: 1, description: "not found", shortDescription: "Short description", imageName: "garbage", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")), placeHolder: PlaceHolderView(header: surgicalProcedure.surgeryTechnicalName, fillerText: "Selecciona un paso  para comenzar"), selectedItem: $selectedStep)
    }
    
    var mainContent: some View {
        ScrollView {
            LazyVStack(spacing: 0) { // spacing: 0 para que los divisores toquen los elementos
                ForEach(surgicalProcedure.steps.indices, id: \.self) { index in
                    Button(action: {
                        selectedStep = surgicalProcedure.steps[index]
                    }) {
                        HStack {
                            Text("Paso no. \(surgicalProcedure.steps[index].id)")
                                .font(.title3)
                                .minimumScaleFactor(0.5)
                                .padding()
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading) // Extender ancho al máximo
                        .contentShape(Rectangle()) // Hacer que todo el espacio sea "tocable"
                        .background(selectedStep == surgicalProcedure.steps[index] ? Color.blue : Color.clear) // Cambiar fondo si está seleccionado
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Divisor, excepto después del último elemento
                    if index < surgicalProcedure.steps.count - 1 {
                        Divider().padding(.leading)
                    }
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
            Step(id: 1, description: "Step 1", shortDescription: "short description", imageName: "arm", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
            Step(id: 2, description: "Step 2", shortDescription: "Short description", imageName: "ear", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
        ]
    )
    )
}
