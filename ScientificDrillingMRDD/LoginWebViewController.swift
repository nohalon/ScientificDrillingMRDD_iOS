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

    var requestURL : NSURL?
    var code : String?
    var token : String?
    var userID : String?
    
    let adfs_url = (config.getProperty("getBaseLoginURL") as String) +
                    (config.getProperty("getADFSAuthorize") as String) + "response_type=" +
                    (config.getProperty("getResponseType") as String) + "&client_id=" +
                    (config.getProperty("getClientID") as String) + "&redirect_uri=" +
                    (config.getProperty("getRedirectURI") as String) + "&resource=" +
                    (config.getProperty("getResourceURI") as String)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
                //println(response)
                var codeIndex = response?.rangeOfString("=", options: .BackwardsSearch)?.startIndex
                code = response?.substringFromIndex(codeIndex!)
                // TODO: better to just trim the first character
                code = code?.stringByReplacingOccurrencesOfString("=", withString: "", options: .allZeros, range: nil)
                authenticateUser()
                
                // You don't want to open the redirect uri
                return false
            }
            else {
                // Throw some user error, maybe an alert
                //self.log.DLog("User has failed to log in", function: "webView")
                return false
            }
    }
    
    func authenticateUser() {
        let token_url = (config.getProperty("getBaseLoginURL") as String) +
                        (config.getProperty("getADFSToken") as String)
        
        let request = NSMutableURLRequest(URL: NSURL(string: token_url)!)
        request.HTTPMethod = "POST"

        var postString = "&client_id=" + (config.getProperty("getClientID") as String)
                        + "&grant_type=" + (config.getProperty("getGrantType") as String)
                        + "&redirect_uri=" + (config.getProperty("getRedirectURI") as String)
                        + "&code=" + self.code!
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //println("Response: \(response)")
    
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            //println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // TODO: error checking needed... access_token not always available
                    self.token = parseJSON["access_token"] as? String
                    println("PRINTING TOKEN")
                    println(self.token)
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
            // Authenticate the user
            if let testToken = self.token {
                self.getUserID()
            }
            else {
                // TODO: Error logging
                println(self.token!)
                println("Token is nil")
            }
        })
        task.resume()
    }
    
    func getUserID() {
        let token_url = config.getProperty("getAuthenticate") as String
        
        let request = NSMutableURLRequest(URL: NSURL(string: token_url)!)
        request.HTTPMethod = "POST"
        
        var postString = "&token=" + self.token!
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                //do something
            }
            else {
                var userID = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("PRINTING UNIQUE USER ID")
                println(userID)
            }
        })
        task.resume()
    }
    
    
    // Cancel goes back to dashboard
    @IBAction func cancel(sender: AnyObject) {
        // some garbage collection
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}