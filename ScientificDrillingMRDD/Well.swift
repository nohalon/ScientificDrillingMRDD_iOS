//
//  Well.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class Well: NSObject {

    var name: String
    var id: Int
    var dashboard: Dashboard
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        dashboard = Dashboard(title: name)
    }
}
