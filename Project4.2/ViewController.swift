//
//  ViewController.swift
//  Project4
//
//  Created by Valeria Belenko on 15/10/2024.
//

import UIKit
@preconcurrency import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var selectedWebsite: String?
    var totalWebsites: Int?
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["github.com", "apple.com", "hackingwithswift.com"]
  
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    //@objc func openTapped() {
    //let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
       
    //for website in websites {
    //    ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    //}
        
    // ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    // ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    // present(ac, animated: true)
    //}
    
    @objc func goBack() {
        if webView.canGoBack {
                webView.goBack()
            }
    }
    
    @objc func goForward() {
        if webView.canGoForward {
                webView.goForward()
            }
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        func blockedWebsite() {
            guard let url = navigationAction.request.url, let host = url.host else {
                decisionHandler(.cancel)
                    return
                }
            
            let ac = UIAlertController(title: "Sorry, this website is not allowed", message: nil, preferredStyle: .alert)
            if !websites.contains(where: { host.contains($0) }) {
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                present(ac, animated: true)
                decisionHandler(.cancel)
                
            } else {
                decisionHandler(.allow)
                 }
        }
        
        
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                    
                }
            }
        }
        blockedWebsite()
        
       // decisionHandler(.cancel)
        
       // let ac = UIAlertController(title: "Sorry, this website is not allowed", message: nil, preferredStyle: .alert)
        //ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //present(ac, animated: true)
        
    }


}

