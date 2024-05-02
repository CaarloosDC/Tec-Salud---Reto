//
//  VideoPlayerView.swift
//  Reto-Tec-Salud
//
//  Created by Carlos DC on 23/04/24.
//

import SwiftUI
import WebKit

struct VideoPlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.layer.cornerRadius = 30 // Set the corner radius here
        webView.clipsToBounds = true    // Ensure subviews are clipped to the rounded corners
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let urlString = "https://www.youtube.com/embed/\(videoID)"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

//struct VideoPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoPlayerView(videoID: "aCj_T07i53o")
//    }
//}
//
//#Preview {
//    VideoPlayerView()
//}
