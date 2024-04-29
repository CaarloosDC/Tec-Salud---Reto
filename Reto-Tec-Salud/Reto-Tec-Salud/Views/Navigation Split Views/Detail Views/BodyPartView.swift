//
//  BodyPartView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct BodyPartView: View {
    // Second window functions
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
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
                    .padding(.bottom)
                
                Text("Procedimientos disponibles:")
                    .font(.subheadline)
                    .padding(.bottom)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(bodyPart?.doableProcedures ?? [], id: \.self) { procedure in
                            Button(action: {
                                selectedProcedure = procedure
                                selected.sentProcedure = procedure
                            }) {
                                HStack {
                                    Text(procedure.surgeryTechnicalName)
                                        .font(.title3)
                                        .minimumScaleFactor(0.5)
                                        .padding()
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .background(selectedProcedure == procedure ? Color.blue : Color.white) // Se utiliza secondarySystemBackground para el fondo transparente
                                .opacity(0.7)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Se añade un divisor después de cada botón, excepto el último
                            if bodyPart?.doableProcedures.last != procedure {
                                Divider()
                            }
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(.horizontal)
            
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
                        selected.sentProcedure = selectedProcedure
                        volumeData.sentRenderName = bodyPart?.renderName
                        
                        switch contentType {
                        case .threedimentional:
                            openWindow(id: "SurgeryDetailContentWindow")
                            Task {
                                await openImmersiveSpace(id: "ObjectTrackingImmersiveSpace")
                            }
                            
                        case .bidimentional:
                            openWindow(id: "SecondWindow")
                            
                        }
                    }) {
                        HStack(alignment: .center) {
                            Text("Estudiar \(selectedProcedure?.surgeryTechnicalName ?? "Procedimiento desconocido")")
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
                Step(id: 1, description: "Step 1", shortDescription: "empty", imageName: "arm", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
                Step(id: 2, description: "Step 2", shortDescription: "empty", imageName: "ear", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            ]
        )])), contentType: .bidimentional)
    }
}

// MARK: If the selected view is the scanner view, set to threedimentional, if a normal procedure, select bidimentional
enum ContentType {
    case threedimentional, bidimentional
}
