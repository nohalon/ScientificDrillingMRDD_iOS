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
    
    // Key-value list of wellnames to available curve names
    var curves = [String:[String]]()
    
    func loadCurvesForWell(wellName: String) {
        
        var urlString = "http://127.0.0.1:5000/getCurvesForWell?well=" + wellName
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        curves[wellName] = [String]()
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSArray {
                    
                    for x in jsonResult as NSArray {
                        self.curves[wellName]!.append(x as String)
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
    
    func loadAllCurves(wells : [Well]) {
        for well in wells {
            loadCurvesForWell(well.name)
        }
    }
}

