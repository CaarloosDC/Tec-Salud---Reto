//
//  SurgeryDetailView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct SurgeryDetailView: View {
    @State var bodyParts = BodyPartViewModel()
    @State var selectedBodyPart: BodyPart?
    
        var body: some View {
            NavigationSplitView{
                List(bodyParts.bodyParts) { bodyPart in
                

                }
            } detail: {
                <#code#>
            }
            .padding()
        }
    }


#Preview {
    SurgeryDetailView()
}
