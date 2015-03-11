//
//  WellsManagerTests.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 3/9/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation
import UIKit
import XCTest

var testCount = 0
var testWellMngr = WellsManager()

class WellsManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        if testCount == 0 {
            testWellMngr.loadWells()
            sleep(1)
        
            for well in testWellMngr.wells {
                testWellMngr.loadCurvesForWell(well)
                sleep(1)
            }
            
            testCount++
        }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddWell() {
        let beforeCount = testWellMngr.wells.count
        let id = "12345"
        let name = "TestWell"
        
        testWellMngr.addWell(id, name: name)
        
        let afterCount = testWellMngr.wells.count
        XCTAssert(afterCount == beforeCount + 1, "Number of wells did not increase after adding a well")
        
        let newWell = testWellMngr.wells[afterCount - 1]
        XCTAssert(newWell.id == id, "Latest added well's id does not match the id provided to addWell")
        XCTAssert(newWell.name == name, "Latest added well's name does not match the name provided to addWell")        
    }
   
    func testAddLotsOfWells() {
        
        for num in 1...1000 {
            let beforeCount = testWellMngr.wells.count
            let id = "\(num)"
            let name = "TestWell\(num)"
            
            testWellMngr.addWell(id, name: name)

            let afterCount = testWellMngr.wells.count
            XCTAssert(afterCount == beforeCount + 1, "Number of wells did not increase after adding a well")
            
            let newWell = testWellMngr.wells[afterCount - 1]
            XCTAssert(newWell.id == id, "Latest added well's id does not match the id provided to addWell")
            XCTAssert(newWell.name == name, "Latest added well's name does not match the name provided to addWell")
        }
    }
    
    func testLoadWells() {
        XCTAssert(testWellMngr.wells.count > 0, "No wells loaded")
    }
    
    func testLoadCurvesForWell() {
        var wellList = testWellMngr.wells
        var loadedSomeTCurves = false
        var loadedSomeWCurves = false
        
        for var idx = 0; idx < wellList.count && !loadedSomeTCurves && !loadedSomeWCurves; idx++ {
            loadedSomeTCurves |= wellList[idx].tCurves.count > 0
            loadedSomeWCurves |= wellList[idx].wCurves.count > 0
        }
        
        XCTAssert(loadedSomeTCurves, "No time curves loaded")
        XCTAssert(loadedSomeWCurves, "No wellbore curves loaded")
    }
    
    func testUpdateDashboardForWell() {
        var testWell = testWellMngr.wells[0]
        var testCurve = testWell.tCurves[0]
        testWell.dashboard.addVisualization(VisualizationType.StaticValue, curve: testCurve)
        
        let latestDV = testWell.dashboard.staticNumberDV.count - 1
        let beforeValue = testWell.dashboard.staticNumberDV[latestDV].curve.values.last!.1
        
        testWellMngr.updateDashboardForWell(testWell)
        sleep(1)
        
        let afterValue = testWell.dashboard.staticNumberDV[latestDV].curve.values.last!.1
        XCTAssert(beforeValue != afterValue, "Value did not change when dashboard was updated")
    }
    
    func testParseDV() {
        println(testWellMngr.parseDV("Time vs. Depth"))
        XCTAssert(testWellMngr.parseDV("Time vs. Depth") == "Depth", "DV was not parsed correctly")
        XCTAssert(testWellMngr.parseDV("Depth") == "", "DV was not parsed correctly")
        XCTAssert(testWellMngr.parseDV("Depth Time") == "", "DV was not parsed correctly")
        XCTAssert(testWellMngr.parseDV("Depth v Time") == "", "DV was not parsed correctly")
        XCTAssert(testWellMngr.parseDV("Depth vs Time") == "", "DV was not parsed correctly")
        XCTAssert(testWellMngr.parseDV("Depth vs. Gamma Ray") == "Gamma Ray", "DV was not parsed correctly")
    }
    
    func testParseIV() {
        XCTAssert(testWellMngr.parseIV("True Vertical Depth vs. Inclination") == "True Vertical Depth", "IV was not parsed correctly")
        XCTAssert(testWellMngr.parseIV("Depth") == "", "IV was not parsed correctly")
        XCTAssert(testWellMngr.parseIV("Depth Time") == "", "IV was not parsed correctly")
        XCTAssert(testWellMngr.parseIV("Depth v Time") == "", "IV was not parsed correctly")
        XCTAssert(testWellMngr.parseIV("Depth vs Time") == "", "IV was not parsed correctly")
    }
}
