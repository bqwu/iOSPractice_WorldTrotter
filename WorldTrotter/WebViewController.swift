//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Baoqiang Wu on 7/20/21.
//

// three fingers can be used to swipe up/down in the Simulator

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    let myURL = URL(string: "https://bignerdranch.com")
//    let myURL = URL(string: "https://cn.bing.com")
//    let myURL = URL(string: "https://www.apple.com")
//    let myURL = URL(string: "https://www.jianshu.com/u/040395b7230c")
    
    var webView = WKWebView()
    
    let navigationBarHeight = 44
    var navigationBar = UINavigationBar()
    var barItem = UINavigationItem()
    
    var statusBarHeight: CGFloat = 0
    
    var progressBar = UIProgressView()
    let progressBarKeyPath = "estimatedProgress"
    let progressBarHeight = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("WebViewController loaded its view.")
        
        addWebView()
        addNavigationBar()
        addProgressBar()
        
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        view.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: progressBarKeyPath, options: .new, context: nil)
    }
    
    func addWebView() {
//        let statusBarHeight = UIApplication.shared.statusBarFrame.height
//        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        webView = WKWebView(frame: CGRect(x: 0, y: statusBarHeight + CGFloat(navigationBarHeight), width: self.view.frame.width, height: self.view.frame.height))
        
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
}
        
    func addNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: CGFloat(navigationBarHeight)))
        
        navigationBar.backgroundColor = UIColor.white.withAlphaComponent(0.5)
                
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(toBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(toForward))
        
        barItem.rightBarButtonItem = forwardButton
        barItem.leftBarButtonItem = backButton
        
        navigationBar.setItems([barItem], animated: false)
        
        view.addSubview(navigationBar)
    }
    
    func addProgressBar() {
        progressBar = UIProgressView(frame: CGRect(x: 0, y: Int(statusBarHeight) + navigationBarHeight - progressBarHeight, width: Int(self.view.frame.width), height: progressBarHeight))
        
        progressBar.progress = 0.0
        progressBar.tintColor = UIColor.blue
//        progressBar.alpha = 0.7
        
        view.addSubview(progressBar)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.title ?? "No title?")
        barItem.title = webView.title
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.progressBarKeyPath {
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: { () -> Void in self.progressBar.alpha = 0.0 }, completion: { (finished: Bool) -> Void in self.progressBar.progress = 0 })
            }
            else {
                self.progressBar.alpha = 1.0   // must be here but I don't know why
                self.progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
            }
        }
    }

}
