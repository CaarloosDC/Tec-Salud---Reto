//
//  StepDetailView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct StepDetailView: View {
    var stepNo: Step
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Paso No. \(stepNo.id)")
                .font(.title)
            Text("Descripción del paso no. \(stepNo.id)")
                .font(.footnote)
        }
        
    }
}

#Preview {
    StepDetailView(stepNo: Step(id: 1, description: "Do something", imageName: "garbage"))
}
