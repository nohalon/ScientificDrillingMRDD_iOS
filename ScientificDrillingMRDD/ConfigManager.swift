//
//  ConfigManager.swift
//  ScientificDrillingMRDD
//
//  Created by Kevin Backers on 2/12/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation


var config: ConfigManager = ConfigManager()


class ConfigManager: NSObject {
    
    var dict = NSDictionary()
    
    func loadPropertiesFromFile() {
        var path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist")
        dict = NSDictionary(contentsOfFile: path!)!
    }
    
    func getProperty(property: String) -> AnyObject {
        return dict[property]!
    }
    
}