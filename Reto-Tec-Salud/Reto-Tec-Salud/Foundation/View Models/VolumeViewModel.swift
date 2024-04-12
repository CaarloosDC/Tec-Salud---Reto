//
//  VolumeViewModel.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/12/24.
//

import Foundation

@Observable
final class VolumeViewModel {
    var volumeRotationAngle: Double
    var sentRenderName: String?
    
    init(volumeRotationAngle: Double, sentRenderName: String? = nil) {
        self.volumeRotationAngle = volumeRotationAngle
        self.sentRenderName = sentRenderName
    }
}
