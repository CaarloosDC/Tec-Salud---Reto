//
//  NavigationView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 18/03/24.
//

import SwiftUI

struct NavigationView: View {
    @State private var selectedView: String?
    
    var body: some View {
        NavigationStack {
            Group {
                if selectedView == "Anatomy" {
                    AnatomyStudyView()
                } else if selectedView == "Medic Chat" {
                    MultiturnChatView()
                } else {
                    ProcedimentStudyView()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomOrnament) {
                    Button(action: {selectedView = "Procediment" }) {
                        Image(systemName: "person.fill")
                        Text("Procedimiento")
                    }
                    Spacer()
                    Button(action: {selectedView = "Anatomy" }) {
                        Image(systemName: "figure")
                        Text("Anatomía")
                    }
                    Spacer()
                    Button(action: {selectedView = "Medic Chat" }) {
                        Image(systemName: "ellipsis.message.fill")
                        Text("Medi-Chat")
                    }
                }
            }
//            .navigationTitle("MedVision")
        }
    }
}


#Preview {
    NavigationView()
}
