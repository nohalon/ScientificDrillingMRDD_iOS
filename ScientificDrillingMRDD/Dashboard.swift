//
//  Dashboard.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class Dashboard: NSObject {
    
    var title: String
    var dataVisualizations: [DataVisualization]
    
    init(title: String) {
        self.title = title
        dataVisualizations = [DataVisualization]()
    }
    
    func addVisualization(type: VisualizationType, id: Int, name: String) {
        dataVisualizations += [(DataVisualization(type: type, curveId: id, label: name))]
    }
    
    func addVisualization(visualization: DataVisualization) {
        dataVisualizations += [visualization]
    }
    
    func printDashboard() {
        println("TITLE: " + title)
        for var i = 0; i < dataVisualizations.count; i++ {
            println("---------------------")
            println("DV" + String(i))
            println("LABEL: " + dataVisualizations[i].label)
            println(dataVisualizations[i].currentValue)
        }
    }
}
