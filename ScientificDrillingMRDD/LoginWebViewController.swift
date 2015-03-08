//
//  LoginWebViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 2/17/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class LoginWebViewController : UIViewController, UIWebViewDelegate {
    let log = Logging()
    
    @IBOutlet var webView: UIWebView!
    
    var authenticator : Authenticator?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        authenticator = Authenticator(controller: self)
        let request = NSURLRequest(URL: authenticator!.requestURL!)
        webView?.loadRequest(request)
    }
    
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            return authenticator!.parseRequest(request);
    }
    
    // Cancel goes back to dashboard
    @IBAction func cancel(sender: AnyObject) {
        // some garbage collection
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LogoutSegue2" {
            let navigationController = segue.destinationViewController as LoginViewController
            
            navigationController.loginSuccessful = true;
        }
    }
    
    func segueToDashboard() {
        self.performSegueWithIdentifier("LogoutSegue2", sender : self)
    }
    
}