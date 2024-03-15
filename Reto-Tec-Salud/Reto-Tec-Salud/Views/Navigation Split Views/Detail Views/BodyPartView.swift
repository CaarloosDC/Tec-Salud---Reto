//
//  BodyPartView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct BodyPartView: View {
    @Binding var bodyPart: BodyPart?
    @State  var selectedProcedure: Procedure? = nil

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(bodyPart?.medicalName ?? "No data recieved")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Text("Procedimientos disponibles:")
                    .font(.subheadline)
                    .padding()
                
                
                List(bodyPart?.doableProcedures ?? []) { procedure in
                    Button(action: {
                        selectedProcedure = procedure
                    }) {
                        HStack {
                            Text(procedure.surgeryTechnicalName)
                                .padding()
                            Spacer()
                        }
                        .background(selectedProcedure == procedure ? Color.blue : Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(maxWidth: 200)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .listStyle(InsetListStyle())
            }
            .padding()
            
            VStack {
                ZStack {
                    Image(bodyPart?.imageName ?? "arm")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                        .padding()
                    
                    Color.clear.frame(maxHeight: 450)
                }
                
                if let procedure = selectedProcedure {
                    NavigationLink(destination: SurgeryStepByStepView(surgicalProcedure: procedure)) {
                        HStack(alignment: .center) {
                            Text("Go to \(procedure.surgeryTechnicalName)")
                                .foregroundStyle(.white)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .frame(maxWidth: 300)
                    }
                    Spacer()
                } else {
                    Spacer()
                }
            }
        }
        .onChange(of: bodyPart) { oldValue, newValue in
            selectedProcedure = nil
        }
    }
}

struct BodyPartView_Previews: PreviewProvider {
    static var previews: some View {
        BodyPartView(bodyPart:.constant(BodyPart(id: .Arm, medicalName: "Brachium", imageName: "arm", renderName: "Skeleton", doableProcedures: [Procedure(
            id: 1,
            surgeryTechnicalName: "Dummy Surgery",
            description: "This is a dummy procedure for testing purposes.",
            steps: [
                Step(id: 1, description: "Step 1", shortDescription: "empty", imageName: "arm"),
                Step(id: 2, description: "Step 2", shortDescription: "empty", imageName: "ear")
            ]
        )])))
    }
}
