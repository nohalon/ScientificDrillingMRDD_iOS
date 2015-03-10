//
//  DashboardTest.swift
//  ScientificDrillingMRDD
//
//  Created by Jonathan Pae on 3/9/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import ScientificDrillingMRDD
import XCTest

class DashboardTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddVisualization() {
        var dash : Dashboard = Dashboard()
        
        XCTAssert(dash.lineDV.count == 0, "Dashboard has been initialized incorrectly")
        dash.addVisualization(.Line, curve: Curve(id: "testID1", dv: "Depth"))
        XCTAssert(dash.lineDV.count == 1, "AddVisualization incorrectly added Line DataVisualization")
        XCTAssert(dash.gaugeDV.count == 0, "Dashboard has been initialized incorrectly")
        XCTAssert(dash.staticNumberDV.count == 0, "Dashboard has been initialized incorrectly")
        dash.addVisualization(.Line, curve: Curve(id: "testID2", dv: "Inclination"))
        XCTAssert(dash.lineDV.count == 2, "AddVisualization incorrectly added Line DataVisualization")
        dash.addVisualization(.StaticValue, curve: Curve(id: "testID3", dv: "Temperature"))
        XCTAssert(dash.staticNumberDV.count == 1, "AddVisualization incorrectly added StaticValue DataVisualization")
        dash.addVisualization(.Gauge, curve: Curve(id: "tedv: stID4", dv: "Gamma"))
        XCTAssert(dash.gaugeDV.count == 1, "AddVisualization incorrectly added Guage DataVisualization")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
