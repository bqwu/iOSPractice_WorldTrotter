//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Baoqiang Wu on 7/20/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView = WKWebView()
    
    let navigationBarHeight = 44
    var statusBarHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("WebViewController loaded its view.")
        
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        webView = WKWebView(frame: CGRect(x: 0, y: statusBarHeight + CGFloat(navigationBarHeight), width: self.view.frame.width, height: self.view.frame.height))
        
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        
        // three fingers can be used to swipe up/down in the Simulator
        let myURL = URL(string: "https://bignerdranch.com")
//        let myURL = URL(string: "https://cn.bing.com")
//        let myURL = URL(string: "https://www.apple.com")
//        let myURL = URL(string: "https://www.jianshu.com/u/040395b7230c")
        
        let myRequest = URLRequest(url: myURL!)
        
        webView.load(myRequest)
        
        view.addSubview(webView)
    }
        
    func addNavigationBar() {
        let bar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: CGFloat(navigationBarHeight)))
        
        bar.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        let barItem = UINavigationItem(title: webView.title ?? "No title")
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(toBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(toForward))
        
        barItem.rightBarButtonItem = forwardButton
        barItem.leftBarButtonItem = backButton
        
        bar.setItems([barItem], animated: false)
        
        view.addSubview(bar)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.title ?? "No title?")
        addNavigationBar()
    }
    
    @objc func toBack() {
        if self.webView.canGoBack {
            print("Website going back")
            self.webView.goBack()
        }
    }
    
    @objc func toForward() {
        if self.webView.canGoForward {
            print("Website going forward")
            self.webView.goForward()
        }
    }
}
