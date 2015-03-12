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
    
    var values : [(Float, Float)]// assumes ordered
    
    init(id: String, dv : String, iv : String) {
        self.id = id
        self.dv = dv
        self.iv = iv
        self.values = [(Float, Float)]()
    }
    
    
    func updateValues(xVal : [NSString], yVal : [NSString]) {
        var temp : [(Float, Float)] = [(Float, Float)]()
        for ndx in 0...xVal.count - 1 {
            //TODO : TELL daniel
            temp += [(xVal[ndx].floatValue, yVal[ndx].floatValue)]
        }
        values = temp
    }
    
    
}