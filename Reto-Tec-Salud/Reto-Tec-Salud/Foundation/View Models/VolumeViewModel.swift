//
//  VolumeViewModel.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/12/24.
//

import Foundation

@Observable
class VolumeViewModel: ObservableObject {
    var sentRenderName: String
    
    init() {
        sentRenderName = "Arm"
    }
}
