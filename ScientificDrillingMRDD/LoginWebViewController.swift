//
//  LoginWebViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 2/17/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

// KNOWN ISSUES:
//   1. User has to click Sign in TWICE with correct credentials (ran on iPhone6 simulator)

class LoginWebViewController : UIViewController, UIWebViewDelegate {
    let log = Logging()
    
    @IBOutlet var webView: UIWebView!
    
    var authenticator = Authenticator()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        let request = NSURLRequest(URL: authenticator.requestURL!)
        webView?.loadRequest(request)
    }
    
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            
            let returnval = authenticator.parseCode(request)

            
            return returnval;
    }
    
    func webViewDidFinishLoad(webview : UIWebView) {
        println("Hello....")
    }
    
    // Cancel goes back to dashboard
    @IBAction func cancel(sender: AnyObject) {
        // some garbage collection
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}