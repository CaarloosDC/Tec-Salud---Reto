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
        var body: some View {
            NavigationStack{
                HStack {
                    Image("arm")
                        .scaleEffect(0.25)
                        .frame(maxWidth: 250, maxHeight: 250)
//                        .shadow(radius: 15)
                        .padding(.bottom, 70)
                    VStack (alignment: .leading) {
                        Text("Braquioplastía").font(.extraLargeTitle)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.").font(.subheadline)
                        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.").font(.subheadline)
                        NavigationLink {
                        } label: {
                            Text("Comenzar cirugía")
                            Image(systemName: "rotate.3d.fill")
                        }
                    }.scaleEffect(1)
                        .frame(width: 400, height: 380)
                        .padding(30)
                }
                .padding()
            }
            .padding()
        }
    }


#Preview {
    SurgeryDetailView()
}
