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
            
            // Logic to choose different device icons depending on the connected device
            switch deviceName {
            case deviceID.iPad.rawValue:
                Image(systemName: "ipad.landscape")
                    .font(.system(size: 25))
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
            case deviceID.iPhone.rawValue:
                Image(systemName: "iphone.gen2")
                    .font(.system(size: 25))
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
            default:
                Image(systemName: "ipad.and.iphone")
                    .font(.system(size: 25))
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
            }
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

// Enum for managing device id's
enum deviceID: String {
    case iPhone, iPad
}
