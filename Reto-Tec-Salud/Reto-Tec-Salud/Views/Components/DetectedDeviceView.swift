//
//  DetectedDeviceView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 3/15/24.
//

import SwiftUI

struct DetectedDeviceView: View {
    var deviceName: String
    
    var body: some View {
        HStack {
            Text("\(deviceName)")
                .foregroundColor(.black)
                .bold()
            + Text(" paired! ")
                .foregroundColor(.black)
            
            Image(systemName: "macbook.and.iphone")
                .font(.system(size: 25))
                .foregroundColor(.accentColor)
                .padding(.horizontal)
        }
        .padding()
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 20)
        
    }
}

#Preview {
    DetectedDeviceView(deviceName: "iPhone")
}
