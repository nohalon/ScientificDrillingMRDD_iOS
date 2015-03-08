//
//  Well.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class Well: NSObject {

    var name: String
    var id: String
    
    var tCurves : [TimeCurve]
    var wCurves : [WellboreCurve]
    
    var dashboard : Dashboard
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.dashboard = Dashboard()
        self.tCurves = [TimeCurve]()
        self.wCurves = [WellboreCurve]()
    }
    
    func addTimeCurve(tc : TimeCurve) {
        tCurves += [tc]
    }
    
    func addWellboreCurve(wc : WellboreCurve) {
        wCurves += [wc]
    }
}
