//
//  DashboardManager.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/5/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

var dashMngr: DashboardManager = DashboardManager()

class DashboardManager: NSObject {
    let log = Logging()
    
    // Key-pair list of wellnames to Dashboards
    var dashboards = [String:Dashboard]()
    
    func loadDashboardForWell(wellName: String) {
        if let dash = dashboards[wellName] {
            for dv in dash.dataVisualizations {
                var urlString = config.getProperty("getCurveValueURL") as String + wellName + "&curve=" + dv.label
                urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                var url = NSURL(string: urlString)
                
                // Opens session with server
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error ->Void in
                    if(error != nil) {
                        // If there is an error in the web request, print it to the console
                        self.log.DLog(error.localizedDescription, function: "loadDashboardForWell")
                    }
                    
                    var err: NSError?
                    if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                        
                        if jsonResult is NSArray {
                            for x in jsonResult as NSArray {
                                dv.currentValue = x as Float
                            }
                        }
                        else {
                            self.log.DLog("jsonResult was not an NSArray", function: "loadDashboardForWell")
                        }
                    }
                    
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        self.log.DLog("JSON Error \(err!.localizedDescription)", function: "loadDashboardForWell")
                    }
                })
                
                task.resume()
            }
        }
    }
}

