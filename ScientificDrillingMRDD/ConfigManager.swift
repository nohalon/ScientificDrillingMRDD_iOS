//
//  ConfigManager.swift
//  ScientificDrillingMRDD
//
//  Created by Kevin Backers on 2/12/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

class PropertyManager: NSObject {
    
    static func loadPropertiesFromFile() -> NSDictionary {
        var path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)!
        return dict
    }
}