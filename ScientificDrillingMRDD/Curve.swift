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

    init(id: String, dv : String) {
        self.id = id
        self.dv = dv
    }
}
