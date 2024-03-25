//
//  DetectedDeviceView.swift
//  TecMedTransmiter
//
//  Created by Sebastian Rosas Maciel on 3/14/24.
//

import SwiftUI

struct DetectedDeviceView: View {
    var deviceName: String
    
    var body: some View {
        HStack {
            Text("\(deviceName)")
                .bold()
            + Text(" paired! ")
            
            Image(systemName: "macbook.and.iphone")
                .font(.system(size: 25))
                .foregroundColor(.accentColor)
                .padding(.horizontal)
        }
        .padding()
        .background(Color("light-dark"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
        
    }
}

#Preview {
    DetectedDeviceView(deviceName: "iPhone")
}
