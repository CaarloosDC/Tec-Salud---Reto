//
//  AnatomyDetailView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 01/03/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct AnatomyDetailView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    
    var body: some View {
        NavigationStack{
            HStack {
//                Spacer()
                Model3D(named: "Skeleton", bundle: realityKitContentBundle).scaleEffect(0.15)
                    .frame(maxWidth: 250, maxHeight: 250)
                    .padding(.bottom, 70)
                VStack (alignment: .leading) {
                    Text("Sistema esquelético").font(.extraLargeTitle)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.").font(.subheadline)
                    Button("3D Focus") {
                                        Task {
                                            await openImmersiveSpace(id: "skeletonImmersiveView")
                                        }
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
    AnatomyDetailView()
}
