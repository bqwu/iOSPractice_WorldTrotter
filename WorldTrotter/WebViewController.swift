//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Baoqiang Wu on 7/20/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        webView.scrollView.bounces = false
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("WebViewController loaded its view.")
        
        // three fingers can be used to swipe up/down in the Simulator
        let myURL = URL(string: "https://bignerdranch.com")
//        let myURL = URL(string: "https://cn.bing.com")
        
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
    }
    

}
