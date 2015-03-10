//
//  Authenticator.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 2/24/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

class Authenticator {
    let log = Logging()
    
    var requestURL : NSURL?
    var code : String?
    var token : String?
    var userID : String?
    var config : ConfigManager?
    
    var webController : LoginWebViewController!
    
    var adfs_url : String?
    
    init(controller : LoginWebViewController) {
        config = ConfigManager()
        config?.loadPropertiesFromFile()
        webController = controller
        adfs_url = (config?.getProperty("getBaseLoginURL") as String) +
            (config?.getProperty("getADFSAuthorize") as String) + "response_type=" +
            (config?.getProperty("getResponseType") as String) + "&client_id=" +
            (config?.getProperty("getClientID") as String) + "&redirect_uri=" +
            (config?.getProperty("getRedirectURI") as String) + "&resource=" +
            (config?.getProperty("getResourceURI") as String)
        requestURL = NSURL(string: self.adfs_url!)
    }
    
    func authenticateUser() {
        let token_url = (config?.getProperty("getBaseLoginURL") as String) +
            (config?.getProperty("getADFSToken") as String)
        
        let request = NSMutableURLRequest(URL: NSURL(string: token_url)!)
        request.HTTPMethod = "POST"
        
        var postString = "&client_id=" + (config?.getProperty("getClientID") as String)
            + "&grant_type=" + (config?.getProperty("getGrantType") as String)
            + "&redirect_uri=" + (config?.getProperty("getRedirectURI") as String)
            + "&code=" + self.code!
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.handleError("authenticateUser", message: "Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    self.token = parseJSON["access_token"] as? String
                    if let testToken = self.token {
                        self.getUserID()
                    }
                }
                else {
                    // The json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    self.handleError("authenticateUser", message : "Error could not parse JSON: '\(jsonStr)'")
                }
            }
        })
        task.resume()
    }
    
    func getUserID() {
        let token_url = config?.getProperty("getAuthenticate") as String
        
        let request = NSMutableURLRequest(URL: NSURL(string: token_url)!)
        request.HTTPMethod = "POST"
        
        var postString = "&token=" + self.token!
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            if error != nil {
                self.handleError("getUserID", message: error.localizedDescription)
            }
            else {
                self.userID = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.webController.segueToDashboard()
            }
        })
        task.resume()
    }
    
    /*
    *
    * Return Value: determines whether to show the webpage or not
    */
    func parseRequest(request: NSURLRequest) -> Bool{
        if request.URL.isEqual(self.requestURL!) || request.URL.absoluteString?.rangeOfString(":443") != nil  {
            // You always want to display the adfs_url
            return true
        }
        else if (request.URL.absoluteString?.rangeOfString("code=") != nil){
            let response = request.URL.absoluteString
            var codeIndex = response?.rangeOfString("=", options: .BackwardsSearch)?.startIndex
            code = response?.substringFromIndex(codeIndex!)
            // The code variable still has an equal sign, need to trim that equal sign out
            code = code?.substringFromIndex(advance(minElement(indices(code as String!)), 1))
            self.authenticateUser()
            
            // You don't want to open the redirect uri
            return false
        }
        else {
            // Throw some user error, maybe an alert
            self.handleError("User has failed to log in", message: "webView")
            return false
        }
        
    }
    
    func handleError(functionName : String, message : String) {
        self.log.DLog(message, function: functionName)
    }
    
    
}