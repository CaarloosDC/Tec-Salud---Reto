//
//  ProcedureViewModel.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import Foundation

@Observable
final class ProcedureViewModel {
    var sentProcedure: Procedure?
    
    init(sentProcedure: Procedure?) {
        self.sentProcedure = sentProcedure
    }
}
