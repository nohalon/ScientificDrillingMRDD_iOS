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
    
    var starttime : String = ""
    var endtime : String = ""
    
    var curvesLoaded = 0
    var loadedPlot : Plot!
    var curvesLoadedCallback : (() -> Void)!;
    
    
    override init() {
        config.loadPropertiesFromFile()
        
    }
    
    func addWell(id: String, name: String)
    {
        wells.append(Well(id: id, name: name))
    }
    
    func loadWells()
    {
        let url = NSURL(string: config.getProperty("getBaseURL") as! String + 
                                (config.getProperty("getWellsURL") as! String))
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadWells")
            }
            
            var err: NSError?
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                if jsonResult is NSArray {
                    
                    for x in jsonResult as! NSArray {
                        if let status = x as? NSDictionary {
                            self.addWell(status["id"] as! String, name: status["name"] as! String)
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
    
    func loadCurvesForWell(well: Well, onSuccess: () -> Void) {
        
        var urlString = config.getProperty("getBaseURL") as! String +
                        (config.getProperty("getCurvesURL") as! String) + well.id
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
                    
                    for x in jsonResult["time_curves"] as! NSArray {
                        if let aStatus = x as? NSDictionary {
                            let name : String = aStatus["name"] as! String
                            
                            well.addCurve(Curve(id: aStatus["id"] as! String, dv : name, iv : "Time"))
                        }
                    }
                    
                    for x in jsonResult["wellbore_curves"] as! NSArray {
                        if let aStatus = x as? NSDictionary {
                            let name : String = aStatus["name"] as! String
                            
                            well.addCurve(Curve(id: aStatus["id"] as! String, dv: self.parseDV(name), iv: self.parseIV(name)))
                            
                        }
                    }
                    
                    onSuccess()
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
            getLastValue(well.id, curve: dv.curve)
        }
    }
    
    func updatePlot(wellID : String, plot : Plot, onSuccess: () -> Void) {
        loadedPlot = plot
        curvesLoadedCallback = onSuccess
        for curve in plot.curves {
            loadCurve(wellID, curve: curve, onSuccess: curveLoaded)
        }
    }
    
    func curveLoaded() {
        curvesLoaded++
        if curvesLoaded == loadedPlot.curves.count {
            curvesLoadedCallback()
            curvesLoaded = 0
        }
    }
    
    func getLastValue(wellID : String , curve : Curve) {
        var endTime : String?
        var baseURLString = config.getProperty("getBaseURL") as! String +
            (config.getProperty("getTimeCurve") as! String)
        
        var tags = "?well=" + wellID + "&curve=" + curve.id;

        var urlString = baseURLString + tags
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurve")
            }
            
            var err: NSError?
            
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: nil) {
                if jsonResult is NSArray {
                    if let result = jsonResult as? NSArray {
                        if let nextQuery = result[1] as? NSDictionary {
                            endTime = String(nextQuery["oldIV"]!.longValue)
                        } else {
                            var values = result[0] as! NSArray
                            var lastValue = values[values.count - 1] as! NSArray
                            endTime = String(stringInterpolationSegment: lastValue[0].longValue)
                        }
                        self.loadCurveWithParams(wellID, curve: curve, start: endTime!, end: endTime!)
                    }
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
    
    func loadCurveWithParams(wellID : String, curve : Curve, start : String, end : String) {
        var endTime : String?
        var baseURLString = config.getProperty("getBaseURL") as! String +
            (config.getProperty("getTimeCurve") as! String)
        
        var tags = "?well=" + wellID + "&curve=" + curve.id + "&start=" + start + "&end=" + end;
        
        var urlString = baseURLString + tags
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurve")
            }
            
            var err: NSError?
            
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: nil) {
                if jsonResult is NSArray {
                    if let result = jsonResult as? NSArray {
                        if let values = result[0] as? NSArray {
                            for array in values {
                                var y_value : Int = (array[0].longValue - 116444736000000000) / 10000 // epoch
                            
                                var x_value : Double! = array[1].doubleValue
                                curve.lastValue = (x_value, y_value)
                            }
                        }
                        if let units = result[2] as? NSArray {
                            curve.iv_units = units[0] as! String;
                            curve.dv_units = units[1] as! String;
                        }
                    }
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
    
    func loadCurve(wellID : String, curve : Curve, onSuccess: () -> Void) {
        
        if curve.nextQueryTime != "" {
            starttime = curve.nextQueryTime
        }
        
        var baseURLString = config.getProperty("getBaseURL") as! String +
                        (config.getProperty("getTimeCurve") as! String)
            
        var tags = "?well=" + wellID + "&curve=" + curve.id;
        if starttime != "" {
            tags += "&start=" + starttime + "&end=" + endtime
        }
        
        var urlString = baseURLString + tags
        urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var url = NSURL(string: urlString)
        
        // Opens session with server
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                self.log.DLog(error.localizedDescription, function: "loadCurve")
            }
            
            var err: NSError?
            
            
            if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:nil, error: nil) {
                if jsonResult is NSArray {
                    if let result = jsonResult as? NSArray {
                        if let values = result[0] as? NSArray {
                            for array in values {
                                var y_value : Int = (array[0].longValue - 116444736000000000) / 10000 // epoch
                                var y_value_temp = (array[0].longLongValue - 116444736000000000) / 10000 // epoch

                                var x_value : Int = array[1].longValue
                                var x_value_temp : Double = array[1].doubleValue

                                curve.values += [(x_value_temp, y_value_temp)]
                            }
                        }
                        
                        if let nextQuery = result[1] as? NSDictionary {
                            var nextTime =  nextQuery["startIV"]!.longValue
                            var end = nextQuery["oldIV"]!.longValue
                            
                            curve.nextQueryTime = String(stringInterpolationSegment: nextTime)
                            self.endtime = String(end)
                        }
                        
                        if let units = result[2] as? NSArray {
                            curve.iv_units = units[0] as! String;
                            curve.dv_units = units[1] as! String;
                        }
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                           onSuccess() 
                        })
                        
                    }
                    
                    
//                    let dvValue = (jsonResult["dv_values"] as! NSString).componentsSeparatedByString(",") as! [NSString]
//                    let ivValue = (jsonResult["iv_values"] as! NSString).componentsSeparatedByString(",") as! [NSString]
//                    curve.updateValues(dvValue, yVal: ivValue)
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