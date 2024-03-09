//
//  ContentView.swift
//  ColorsMultipeer
//
//  Created by Sebastian Rosas Maciel on 3/8/24.
//

import SwiftUI

struct ContentView: View {
    @State var colorSession = ColorMultipeerSession()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Connected Devices:")
            Text(String(describing: colorSession.connectedPeers.map(\.displayName)))

            Divider()

            HStack {
                ForEach(Namedcolor.allCases, id: \.self) { color in
                    Button(color.rawValue) {
                        colorSession.send(color: color)
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .padding()
        .background((colorSession.currentColor.map(\.color) ?? .clear).ignoresSafeArea())
    }
}

extension Namedcolor {
    var color: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .yellow:
            return .yellow
        }
    }
}

#Preview {
    ContentView()
}
