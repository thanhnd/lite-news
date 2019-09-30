//
//  BrowserViewController.swift
//  LiteNews
//
//  Created by Thanh Nguyen on 9/30/19.
//  Copyright © 2019 Thanh Nguyen. All rights reserved.
//

import Foundation
import WebKit

class BrowserViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Outlets

    // MARK: - Properties
    var webView: WKWebView!
    public var strUrl: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let strUrl = strUrl, let url = URL(string: strUrl) {
            webView.load(URLRequest(url: url))
            
        }
    }
}
