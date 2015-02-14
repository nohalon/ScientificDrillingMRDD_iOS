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
    
    // Key-pair list of wellnames to Dashboards
    var dashboards = [String:Dashboard]()
    
    func loadDashboardForWell(wellName: String) {
        if let dash = dashboards[wellName] {
            for dv in dash.dataVisualizations {
                var urlString = config.getProperty("getCurveValueURL") as String + wellName + "&curve=" + dv.label
                urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                println(urlString)
                var url = NSURL(string: urlString)
                
                // Opens session with server
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error ->Void in
                    if(error != nil) {
                        // If there is an error in the web request, print it to the console
                        println(error.localizedDescription)
                    }
                    
                    var err: NSError?
                    if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                        
                        if jsonResult is NSArray {
                            println(jsonResult)
                            for x in jsonResult as NSArray {
                                dv.currentValue = x as Float
                            }
                        }
                        else {
                            println("jsonResult was not an NSArray")
                        }
                    }
                    
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }
                })
                
                task.resume()
            }
        }
        else {
            println("No dashboard for well " + wellName)
        }
    }
}

