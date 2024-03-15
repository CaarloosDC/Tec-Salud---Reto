//
//  BodyPartView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct BodyPartView: View {
    @Binding var bodyPart: BodyPart?
    @State private var selectedProcedure: Procedure?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bodyPart?.medicalName ?? "No data recieved")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Procedimientos disponibles:")
                
                List(bodyPart?.doableProcedures ?? []) { procedure in
                    Button(action: {
                        selectedProcedure = procedure
                    }) {
                        Text(procedure.surgeryTechnicalName)
                            .foregroundColor(selectedProcedure == procedure ? .white : .black)
                            .padding()
                            .background(selectedProcedure == procedure ? Color.blue : Color.clear)
                            .cornerRadius(10)
                    }
                }
                if let procedure = selectedProcedure {
                    NavigationLink(destination: SurgeryStepByStepView(surgicalProcedure: procedure)) {
                        Text("Go to \(procedure.surgeryTechnicalName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            Image(bodyPart?.imageName ?? "arm")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 400)
        }
        
    }
}

struct BodyPartView_Previews: PreviewProvider {
    static var previews: some View {
        BodyPartView(bodyPart: .constant(BodyPart(id: .Arm, medicalName: "Brachium", imageName: "arm", renderName: "Skeleton", doableProcedures: [])))
    }
}
