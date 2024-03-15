//
//  SelectedProcedure.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import Foundation
import SwiftUI

struct SelectedProcedure: EnvironmentKey {
    static var defaultValue: Procedure?
}

extension EnvironmentValues {
    var selectedProcedure: Procedure? {
        get { self[SelectedProcedure.self] }
        set { self[SelectedProcedure.self] = newValue }
    }
}
