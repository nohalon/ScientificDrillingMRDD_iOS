//
//  WellboreCurve.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 3/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

class WellboreCurve: Curve {
    var iv : String
    
    init(id: String, dv : String, iv : String) {
        self.iv = iv
        
        super.init(id: id, dv : dv)
    }
}
