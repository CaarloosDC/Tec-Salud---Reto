//
//  NavigationView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 18/03/24.
//

import SwiftUI

struct NavigationView: View {
    var body: some View {
        TabView {
            ProcedimentStudyView().tabItem {
                Image(systemName: "person.fill")
                Text("Procediment")
            }
            AnatomyStudyView().tabItem {
                Image(systemName: "accessibility")
                Text("Anatomy")
            }
            ChatView().tabItem {
                Image(systemName: "ellipsis.message.fill")
                Text("Medic Chat")
            }
        }
    }
}

#Preview {
    NavigationView()
}
