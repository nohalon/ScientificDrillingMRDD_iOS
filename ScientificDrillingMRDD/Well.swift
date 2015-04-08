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
    
    var curves : [String : [Curve]]
    
    var dashboard : Dashboard
    
    var plots = [Plot]()
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.dashboard = Dashboard()
        self.plots = [Plot]()
        self.curves = [String : [Curve]]()
    }
    
    func addCurve(curve : Curve) {
        if self.curves[curve.iv] == nil {
            self.curves[curve.iv] = [Curve]()
        }
        self.curves[curve.iv]!.append(curve)
    }
}


class Plot : NSObject {
    var title : String
    var iv : String
    var curves : [Curve]
    
    init (title : String, iv : String) {
        self.title = title;
        self.iv = iv;
        self.curves = [Curve]();
    }
    
    init (title : String, iv : String, curves : [Curve]) {
        self.title = title;
        self.iv = iv;
        self.curves = curves;
    }
}



