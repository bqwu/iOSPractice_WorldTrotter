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

        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController loaded its view.")
        
        let myURL = URL(string: "https://bignerdranch.com")
//        let myURL = URL(string: "https://cn.bing.com")
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
    }
    

}
