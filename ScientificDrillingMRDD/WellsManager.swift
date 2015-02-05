//
//  WellsManager.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

var wellsMngr: WellsManager = WellsManager()

/*struct Well {
    var name = "some-name"
}*/

class WellsManager: NSObject {
    
    var wells = [Well]()
    
    func addWell(id: Int, name: String)
    {
        wells.append(Well(id: id, name: name))
    }
    
    func loadWells()
    {
        let url = NSURL(string: "http://127.0.0.1:5000/getWells")
        
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
                        wellsMngr.addWell(1, name: String(x as NSString))
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
    
    func getCurvesForWell(name: String) -> [String] {
        //var escapedName = name.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var urlString = "http://127.0.0.1:5000/getCurvesForWell?" + name
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        //let url = NSURL(string: "http://127.0.0.1:5000/getCurvesForWell?" + name)
        var url = NSURL(string: urlString)
        var curveNames = [String]()
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            println("url task")
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSArray {
                    
                    for x in jsonResult as NSArray {
                        curveNames.append(String(x as NSString))
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
    
        return curveNames
    }
   
}
