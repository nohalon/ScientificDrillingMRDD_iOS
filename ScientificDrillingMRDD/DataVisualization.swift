//
//  DataVisualization.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

enum VisualizationType {
    case StaticValue
    case Gauge
    case Line
}

class DataVisualization {
    var type: VisualizationType
    var curveId: Int
    var label: String
    var currentValue: Float?
    
    init(type: VisualizationType, curveId: Int, label: String) {
        self.type = type
        self.curveId = curveId
        self.label = label
    }
}


