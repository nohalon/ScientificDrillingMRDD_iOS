//
//  Dashboard.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class Dashboard: NSObject {
    var staticNumberDV: [DataVisualization]
    var gaugeDV : [DataVisualization]
    var lineDV : [DataVisualization]
    
    override init () {
        staticNumberDV = [DataVisualization]()
        gaugeDV = [DataVisualization]()
        lineDV = [DataVisualization]()
    }
    
    func addVisualization(type: VisualizationType, curve : Curve) {
        switch type {
        case .StaticValue :
            staticNumberDV += [(DataVisualization(type: type, curve : curve))]
        case .Line :
            lineDV += [(DataVisualization(type: type, curve : curve))]
        case .Gauge :
            gaugeDV += [(DataVisualization(type: type, curve : curve))]
        }
    }
}
