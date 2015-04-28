//
//  Curve.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class Curve: NSObject {
    
    var id: String
    var dv : String
    var iv : String
    var iv_units : String
    var dv_units : String
    
    var values : [(Float, Float)]// assumes ordered
    var lastValue : Float
    
    var nextQueryTime : String
    
    init(id: String, dv : String, iv : String) {
        self.id = id
        self.dv = dv
        self.iv = iv
        self.values = [(Float, Float)]()
        self.lastValue = 0.0
        self.iv_units = ""
        self.dv_units = ""
        self.nextQueryTime = ""
    }
    
    
    func updateValues(xVal : [NSString], yVal : [NSString]) {
        var temp : [(Float, Float)] = [(Float, Float)]()
        var count = 0
        
        if xVal.count > yVal.count {
            count = yVal.count
        } else {
            count = xVal.count
        }
        
        for ndx in 0...count - 1 {
            temp += [(xVal[ndx].floatValue, yVal[ndx].floatValue)]
        }
        values = temp
    }
}