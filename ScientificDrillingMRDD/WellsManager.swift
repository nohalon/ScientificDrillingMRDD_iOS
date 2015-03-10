//
//  WellsManager.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

//var wellsMngr: WellsManager = WellsManager()

class WellsManager: NSObject {
    let log = Logging()
    
    var wells = [Well]()
    
    var config = ConfigManager()
    
    
    override init() {
        config.loadPropertiesFromFile()
        
    }
    
    func addWell(id: String, name: String)
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
                self.log.DLog(error.localizedDescription, function: "loadWells")
            }
            
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSArray {
                    
                    for x in jsonResult as NSArray {
                        if let status = x as? NSDictionary {
                            wellsMngr.addWell(status["id"] as String, name: status["name"] as String)
                        }
                    }
                }
                else {
                    self.log.DLog("jsonResult was not an NSArray", function: "loadWells")
                }
            }
            
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                self.log.DLog("JSON Error \(err!.localizedDescription)", function: "loadWells")
            }
        })
        
        task.resume()
    }
    
    func loadCurvesForWell(well: Well) {
        
        var urlString = config.getProperty("getCurvesURL") as String + well.id
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurvesForWell")
            }
            
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSDictionary {
                    
                    for x in jsonResult["time_curves"] as NSArray {
                        if let aStatus = x as? NSDictionary {
                            let name : String = aStatus["name"] as String
                            
                            
                            well.addTimeCurve(TimeCurve(id: aStatus["id"] as String, dv : self.parseDV(name)))
                        }
                    }
                    
                    for x in jsonResult["wellbore_curves"] as NSArray {
                        if let aStatus = x as? NSDictionary {
                            let name : String = aStatus["name"] as String
                            
                            well.addWellboreCurve(WellboreCurve(id: aStatus["id"] as String, dv: self.parseDV(name), iv: self.parseIV(name)))
                            
                        }
                    }
                    
                    println(well.tCurves.count)
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
    
    func parseDV(curveName : String) -> String {
        var array = curveName.componentsSeparatedByString(" vs. ")
        return array[1]
    }
    
    func parseIV(curveName : String) -> String {
        var array = curveName.componentsSeparatedByString(" vs. ")
        return array[0]
    }
    
    
    func updateDashboardForWell(well : Well) {
        let dash = well.dashboard
        var dataVisualizations = dash.staticNumberDV + dash.lineDV + dash.gaugeDV
        
        
        for dv in dataVisualizations {
            var urlString = config.getProperty("getCurveValueURL") as String + "&well=" + well.id + "&curve=" + dv.curve.id
            urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var url = NSURL(string: urlString)
            
            // Opens session with server
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error ->Void in
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    self.log.DLog(error.localizedDescription, function: "updateDashboardForWell")
                }
                
                var err: NSError?
                
                if var dataResult: NSString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    println(dataResult)
                    
                    dataResult = dataResult.stringByReplacingOccurrencesOfString("\"", withString: "")
                    dv.currentValue = (dataResult as NSString).floatValue
                }
                
                
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    self.log.DLog("JSON Error \(err!.localizedDescription)", function: "updateDashboardForWell")
                }
            })
            
            task.resume()
        }
        
        
    }
    
}
