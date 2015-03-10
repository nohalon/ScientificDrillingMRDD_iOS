//
//  WellsManagerTests.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 3/9/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit
import XCTest

class WellsManagerTests: XCTestCase {
    
    var wellsMngr = WellsManager()
    
    override func setUp() {
        super.setUp()
        wellsMngr.loadWells()
        sleep(1)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(wellsMngr.wells.count > 0, "Wells loaded")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
