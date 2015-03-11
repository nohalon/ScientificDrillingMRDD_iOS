//
//  Plot.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 3/11/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//


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