//
//  RowView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct RowView: View {
    var rowLabel: String
    
    var body: some View {
        HStack {
            Text(rowLabel)
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding()
            Spacer()
        }
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: 260)
    }
}

#Preview {
    RowView(rowLabel: "Sample")
}
