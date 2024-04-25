//
//  ChatBotOrnament.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 4/24/24.
//

import SwiftUI

struct ChatBotOrnament: View {
    @State private var isBotVisible = false

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Toggle(isOn: $isBotVisible) {
                    Label("MedBot", systemImage: "bubble.circle")
                }
                .help("MedBot")
                .toggleStyle(.button)
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
                .glassBackgroundEffect(in: .circle)
                
                if isBotVisible {
                    MultiturnChatView()
                        .padding()
                        .glassBackgroundEffect(in: .rect(cornerRadius: 20))
                        .transition(.move(edge: .trailing))
                }
            }
            .padding(.trailing)
        }
    }
}

#Preview {
    ChatBotOrnament()
}
