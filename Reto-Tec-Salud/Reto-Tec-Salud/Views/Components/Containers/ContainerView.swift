//
//  ContainerView.swift
//  Reto-Tec-Salud
//
//  Created by Sebastian Rosas Maciel on 5/29/24.
//

import SwiftUI

/// Struct meant to serve as a container for both text and media content, it already sets pre-defined parameters for all the text and backgrounds to be the same
struct ContainerView: View {
    let contentType: ContainerContentType
    let containerText: String?
    let mediaName: String?
    
    var media: Image {
        return Image(mediaName ?? "garbage")
    }
    
    private var containerColor: Color {
        switch self.contentType {
        case .titleText:
            return Color("caribbean green")
        case .subtitleText:
            return Color("cerulean")
        default:
            return Color(.white)
        }
    }
    var body: some View {
        HStack{
            Spacer()
            
            VStack {
                switch contentType {
                case .titleText: // Caribbean green background, overflowing text
                    Text(containerText ?? "No text provided")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                case .paragraphText: // Overflowing text, black font
                    Text(containerText ?? "No text provided")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                        
                case .media:
                    media
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .shadow(radius: 10)
                case .subtitleText: // Celurean background, not that much overflow
                    Text(containerText ?? "No text provided")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                }
            }
            .padding()
    
            Spacer()
        }
        .background(containerColor.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ContainerView(contentType: .subtitleText , containerText: "Sample text", mediaName: "garbage")
}

// Enumerator for managing container content cases
enum ContainerContentType {
    case titleText
    case paragraphText
    case subtitleText
    case media
}
