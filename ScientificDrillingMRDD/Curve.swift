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
    var dv: String
    var iv: String
    var iv_units: String
    var dv_units: String
    var wellbore_id: String?
    
    var values: [(Double, Int64)]// assumes ordered
    var lastValue: (Double, Int64)
    
    var nextQueryTime: String
    
    init(id: String, dv: String, iv: String, wellbore: String?) {
        self.wellbore_id = wellbore
        self.id = id
        self.dv = dv
        self.iv = iv
        self.values = [(Double, Int64)]()
        self.lastValue = (0, 0)
        self.iv_units = ""
        self.dv_units = ""
        self.nextQueryTime = ""
    }
    
    convenience init(id: String, dv: String, iv: String) {
        self.init(id: id, dv: dv, iv: iv, wellbore: nil)
    }
    
    
    func updateValues(xVal : [NSString], yVal : [NSString]) {
        var temp : [(Double, Int64)] = [(Double, Int64)]()
        var count = 0
        
        if xVal.count > yVal.count {
            count = yVal.count
        } else {
            count = xVal.count
        }
        
        for ndx in 0...count - 1 {
            temp += [(xVal[ndx].doubleValue, Int64(yVal[ndx].longLongValue))]
        }
        values = temp
    }
}