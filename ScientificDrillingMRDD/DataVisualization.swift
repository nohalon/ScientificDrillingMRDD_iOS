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
    var curve : Curve
    
    init(type: VisualizationType, curve: Curve) {
        self.type = type
        self.curve = curve
    }
}