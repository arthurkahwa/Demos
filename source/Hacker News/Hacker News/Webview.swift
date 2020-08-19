//
//  Webview.swift
//  Hacker News
//
//  Created by Arthur Nsereko Kahwa on 7/2/20.
//  Copyright © 2020 Arthur Nsereko Kahwa. All rights reserved.
//

import Foundation
import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {

    var url: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView.pageNotFoundView()
        }

        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.load(request)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: self.url) else {
            return
        }

        let request = URLRequest(url: url)
        uiView.load(request)
    }

}
