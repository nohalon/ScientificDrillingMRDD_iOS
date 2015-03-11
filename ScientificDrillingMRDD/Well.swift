//
//  Well.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//


class Well: NSObject {
    
    var name: String
    var id: String
    
    var tCurves : [Curve]
    var wCurves : [Curve]
    
    var dashboard : Dashboard
    
    var plots : [Plot]
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.dashboard = Dashboard()
        self.tCurves = [Curve]()
        self.wCurves = [Curve]()
        self.plots = [Plot]()
        
    }
    
    func addTimeCurve(tc : Curve) {
        tCurves += [tc]
    }
    
    func addWellboreCurve(wc : Curve) {
        wCurves += [wc]
    }
}
