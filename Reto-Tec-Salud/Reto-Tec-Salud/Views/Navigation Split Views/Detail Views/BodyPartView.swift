//
//  BodyPartView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct BodyPartView: View {
    // Second window functions
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    @Binding var bodyPart: BodyPart?
    @State  var selectedProcedure: Procedure? = nil
    @Environment(ProcedureViewModel.self) private var selected
    @Environment(VolumeViewModel.self) private var volumeData
    
    var contentType: ContentType
    
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
                        selected.sentProcedure = procedure
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
                    .buttonStyle(.plain)
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
                
                if selectedProcedure != nil {
                    Button(action: {
                        Task {
                            selected.sentProcedure = selectedProcedure
                            volumeData.sentRenderName = bodyPart?.renderName
                            
                            switch contentType {
                            case .threedimentional:
                                openWindow(id: "SurgeryDetailContentWindow")
                                await openImmersiveSpace(id: "bodyPartImmersiveView")
                                
                            case .bidimentional:
                                openWindow(id: "SecondWindow")
                            }
                        }
                    }) {
                        HStack(alignment: .center) {
                            Text("Go to \(selectedProcedure?.surgeryTechnicalName ?? "Unknown Procedure")")
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)

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
        )])), contentType: .bidimentional)
    }
}

// MARK: If the selected view is the scanner view, set to threedimentional, if a normal procedure, select bidimentional
enum ContentType {
    case threedimentional, bidimentional
}
