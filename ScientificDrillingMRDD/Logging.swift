//
//  Logging.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 2/16/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

class Logging {
    func DLog(message: String, function: String = __FUNCTION__) {
        #if DEBUG
            println("\(function): \(message)")
        #endif
    }
}