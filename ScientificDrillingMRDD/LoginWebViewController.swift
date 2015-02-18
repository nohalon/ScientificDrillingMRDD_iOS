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
    
    let adfs_url = "https://capstone2015federation.scientificdrilling.com/adfs/oauth2/authorize?response_type=code&client_id=7e3e1419-204e-4038-b594-80e812d20c6f&redirect_uri=http://localhost:8000/callback&resource=https://mrdd"
    var requestURL : NSURL?
    var code : String?
    
    /* config.getProperty("getBaseLoginURL") as String +
    config.getProperty("getADFSAuthorize") as String + "response_type=" +
    config.getProperty("getResponseType") as String + "&client_id=" +
    config.getProperty("getClientID") as String + "&redirect_uri=" +
    config.getProperty("getRedirectURI") as String + "&resource=" +
    config.getProperty("getResourceURI") as String 
    
    Might want to look into NSURLComponent */
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        
        requestURL = NSURL(string: adfs_url)
        let request = NSURLRequest(URL: requestURL!)
        webView?.loadRequest(request)
    }
    
    func webView(webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest,
        navigationType: UIWebViewNavigationType) -> Bool {
            if request.URL.isEqual(requestURL)  {
                // You always want to display the adfs_url
                return true
            }
            else if (request.URL.absoluteString?.rangeOfString("code=") != nil){
                let response = request.URL.absoluteString
                var codeIndex = response?.rangeOfString("=", options: .BackwardsSearch)?.startIndex
                code = response?.substringFromIndex(codeIndex!)
                // TODO: better to just trim the first character
                code = code?.stringByReplacingOccurrencesOfString("=", withString: "", options: .allZeros, range: nil)
                getToken()
                // You don't want to open the redirect uri
                return false
            }
            else {
                // Throw some user error, maybe an alert
                self.log.DLog("User has failed to log in", function: "webView")
                return false
            }
    }
    
    func getToken() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://capstone2015federation.scientificdrilling.com/adfs/oauth2/token")!)
        request.HTTPMethod = "POST"
        let postString = "client_id=7e3e1419-204e-4038-b594-80e812d20c6f&redirect_uri=https://localhost:8000/callback" +
                            "&code=" + self.code!
        println("@@@@@@@@@@@@@@@@@@@@@@@")
        println(postString)
        println("AAAAAAAAAAAAAAAAAAAAAAAA")
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        println(request)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            gprintln("responseString = \(responseString)")
        }
        task.resume()
    }
    
    
    // Cancel goes back to dashboard
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}