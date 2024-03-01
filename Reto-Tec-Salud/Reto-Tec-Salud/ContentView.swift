//
//  ContentView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 29/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Text("¡Bienvenido a MedVision!").font(.extraLargeTitle)
            HStack {
                Model3D(named: "Skeleton", bundle: realityKitContentBundle).scaleEffect(0.17)
                    .frame(maxWidth: 250, maxHeight: 450)
                    .padding(.bottom, 70)
                VStack (alignment: .leading) {
                        Text("Estamos emocionados de que te unas a la revolución de la educación médica con nosotros. MedVision, diseñada exclusivamente para los Apple Vision Pro, está aquí para transformar tu aprendizaje con tecnología de vanguardia. Prepárate para explorar los accesos quirúrgicos como nunca antes, mediante modelos 3D altamente detallados que puedes visualizar y manipular con facilidad.").font(.subheadline)
                        Text("Nuestra inteligencia artificial está lista para responder todas tus preguntas, guiándote a través de cada paso de tu educación. Además, nuestra avanzada tecnología de machine learning enriquecerá tu experiencia, superponiendo imágenes precisas sobre un dummy o paciente real, o incluso generando un paciente virtual para prácticas sin riesgos.").font(.subheadline)
                        Text("Sea que estés practicando procedimientos, estudiando la anatomía humana o preparándote para un examen, MedVision es tu compañero perfecto. ¡Emprende este viaje hacia el futuro de la educación médica con nosotros y lleva tus habilidades al próximo nivel!").font(.subheadline)
                        Text("Comienza explorando nuestras funciones y descubre cómo MedVision puede cambiar tu forma de aprender.").font(.subheadline)
//                        Spacer()
                }.scaleEffect(1.2)
                .frame(width: 630, height: 380)
                .padding(30)
                
                
            }
            .padding()
        }
        .navigationTitle("Mini Space Center")
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
