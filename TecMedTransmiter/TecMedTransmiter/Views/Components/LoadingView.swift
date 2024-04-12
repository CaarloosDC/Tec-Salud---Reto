//
//  LoadingView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Bienvenido a TecMed Transmiter!")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                Spacer() // Spacer to occupy horizontal space
                Image(systemName: "macbook.and.iphone")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)
                Spacer() // Spacer to occupy horizontal space
            }
            
            ProgressView()
                .scaleEffect(2)
                .padding()
            
            Text("Cargando ...")
                .font(.footnote)
                .padding()
            
            Spacer()
        }
        .background(.thinMaterial)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoadingView()
}
