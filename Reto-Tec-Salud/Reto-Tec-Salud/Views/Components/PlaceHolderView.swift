//
//  RowView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct PlaceHolderView: View {
    @State private var isSelected = false
    var header, fillerText: String
    
    var body: some View {
        VStack {
            Text("¡Bienvenidx a \(header)!")
                .font(.extraLargeTitle2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(fillerText)
                .multilineTextAlignment(.leading)
                .padding()
        }
        .padding()
    }
}

#Preview {
    PlaceHolderView(header: "Cirugia Virtual", fillerText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ac metus nec mauris ullamcorper cursus nec sit amet dui. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis vehicula ligula sit amet lacus tristique convallis. Sed sodales venenatis aliquam. Fusce posuere lacus eget arcu gravida, sit amet lacinia est posuere. Nullam convallis vehicula libero, ac posuere leo tincidunt non. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Aenean in orci neque. Nulla facilisi.")
}
