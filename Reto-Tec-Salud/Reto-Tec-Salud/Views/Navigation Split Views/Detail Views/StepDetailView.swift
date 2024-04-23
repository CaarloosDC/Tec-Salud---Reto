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
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment:.leading) {
                    Text("Paso No. \(stepNo.id)")
                        .font(.title)
                    Text(stepNo.description)
                        .font(.footnote)
                }
                .padding()
                
                HStack {
                    Image(stepNo.imageName)
                        .resizable()
                        .scaledToFit()
                    VideoPlayerView(videoID: stepNo.videoName).frame(width: 500.0, height: 300.0)
                        .scaleEffect(0.7)
                        .padding()
                    Spacer()
                }
                .frame(maxHeight: 200)
                .padding()
                
                Text(stepNo.description)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
            .padding()
        }
        
        
    }
}

#Preview {
    StepDetailView(stepNo: Step(id: 1, description: "Do something", shortDescription: "Same instruction, just shorter", imageName: "garbage", videoName: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"))
}
