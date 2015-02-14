//
//  WellsManager.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

var wellsMngr: WellsManager = WellsManager()

class WellsManager: NSObject {
    
    var wells = [Well]()
    
    func addWell(id: Int, name: String)
    {
        wells.append(Well(id: id, name: name))
    }
    
    func loadWells()
    {
        let url = NSURL(string: config.getProperty("getWellsURL") as String)
        
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
                        dashMngr.dashboards[x as String] = Dashboard(title: x as String)
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
            
            curveMngr.loadAllCurves(wellsMngr.wells)
        })
        
        task.resume()
    }
   
}
