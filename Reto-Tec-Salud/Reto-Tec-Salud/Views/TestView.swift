//
//  TestView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .ornament(attachmentAnchor: .scene(.bottom)) {
                StepNavigationOrnament()
            }
    }
}

#Preview {
    TestView()
}
