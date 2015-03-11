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
                            self.addWell(status["id"] as String, name: status["name"] as String)
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
                            
                            
                            well.addCurve(Curve(id: aStatus["id"] as String, dv : self.parseDV(name), iv : self.parseIV(name)))
                        }
                    }
                    
                    for x in jsonResult["wellbore_curves"] as NSArray {
                        if let aStatus = x as? NSDictionary {
                            let name : String = aStatus["name"] as String
                            
                            well.addCurve(Curve(id: aStatus["id"] as String, dv: self.parseDV(name), iv: self.parseIV(name)))
                            
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
    
    func parseDV(curveName : String) -> String {
        var array = curveName.componentsSeparatedByString(" vs. ")
        if (array.count > 1) {
            return array[1]
        }
        return ""
    }
    
    func parseIV(curveName : String) -> String {
        var array = curveName.componentsSeparatedByString(" vs. ")
        if (array.count > 1) {
            return array[0]
        }
        return ""
    }
    
    
    func updateDashboardForWell(well : Well) {
        let dash = well.dashboard
        var dataVisualizations = dash.staticNumberDV + dash.lineDV + dash.gaugeDV
        
        
        for dv in dataVisualizations {
            loadCurve(dv.curve)
        }
    }
    
    func updatePlot(plot : Plot) {
        for curve in plot.curves {
            loadCurve(curve)
        }
    }
    
    
    func loadCurve(curve : Curve) {
        
        var urlString = config.getProperty("getCurveValues") as String + "curve=" + curve.id
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error ->Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurve")
            }
            
            var err: NSError?
            

            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSDictionary {
                    //TODO: Tell daniel about values being proper json array of FLOATS
                    let dvValue = (jsonResult["dv_values"] as NSString).componentsSeparatedByString(",") as [NSString]
                    let ivValue = (jsonResult["iv_values"] as NSString).componentsSeparatedByString(",") as [NSString]
                    curve.updateValues(dvValue, yVal: ivValue)
                }
                else {
                    self.log.DLog("jsonResult was not an NSArray", function: "loadCurve")
                }
            }

            
            if(err != nil) {
                // If there is an error parsing JSON, print it to the console
                self.log.DLog("JSON Error \(err!.localizedDescription)", function: "loadCurve")
            }
        })
        
        task.resume()
    }
}
