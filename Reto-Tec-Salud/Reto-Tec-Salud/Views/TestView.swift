//
//  TestView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/11/24.
//

import SwiftUI

struct TestView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            

        Button(action: {openWindow(id: "SurgeryDetailContentWindow")}, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
    }
}

#Preview {
    TestView()
}
