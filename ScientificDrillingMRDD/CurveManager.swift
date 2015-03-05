//
//  DashboardManager.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/5/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

var curveMngr: CurveManager = CurveManager()

class CurveManager: NSObject {
    let log = Logging()
    
    // Key-value list of wellnames to available curve names
    var curves = [String:[String]]()
    
    func loadCurvesForWell(wellID: String) {
        
        var urlString = config.getProperty("getCurvesURL") as String + wellID
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        curves[wellID] = [String]()
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurvesForWell")
            }
            
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSDictionary {
                    
                    for x in jsonResult as NSArray {
                        if let aStatus = x as? NSDictionary {
                           self.curves[wellID]!.append(x as String)
                        }
                    }
                }
                else {
                    self.log.DLog("jsonResult was not an NSArray", function: "loadCurvesForWell")
                }
            }
            
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                self.log.DLog("JSON Error \(err!.localizedDescription)", function: "loadCurvesForWell")
            }
        })
        
        task.resume()
    }
    
    func loadAllCurves(wells : [Well]) {
        for well in wells {
            loadCurvesForWell(well.id)
        }
    }
}

