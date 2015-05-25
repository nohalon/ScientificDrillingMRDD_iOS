//
//  DataVisualization.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//


import UIKit
import Foundation

enum VisualizationType {
    case StaticValue
    case Gauge
    case Line
}

class DataVisualization: NSObject, Equatable {
    var type: VisualizationType
    var curve : Curve
    
    init(type: VisualizationType, curve: Curve) {
        self.type = type
        self.curve = curve
    }
}

func ==(lhs: DataVisualization, rhs: DataVisualization) -> Bool {
    return (lhs.curve.id == rhs.curve.id) && (lhs.type == rhs.type)
}