//
//  SecondWindow.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct SecondWindow: View {
    @Environment(MediaViewModel.self) private var stepVideo
    
    var body: some View {
        VStack {
            VideoPlayerView(videoID: stepVideo.stepVideo)
                .padding()
        }
    }
}
