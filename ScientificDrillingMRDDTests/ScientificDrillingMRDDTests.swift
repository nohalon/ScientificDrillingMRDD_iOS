//
//  ScientificDrillingMRDDTests.swift
//  ScientificDrillingMRDDTests
//
//  Created by Noha Alon on 1/14/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit
import XCTest
import ScientificDrillingMRDD

class ScientificDrillingMRDDTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //system("bash RunScript.sh")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        let vc : LoginWebViewController = LoginWebViewController()
        let wellsMngr = WellsManager()
        wellsMngr.loadWells()
        println("WELL COUNT : \(wellsMngr.wells.count)")
        
        let authenticator = Authenticator(controller: vc)
        
        authenticator.code = "bME6zdyD7kSdduzCBTTQUg.bAwq8dgo0gj_ABQ9f0Wka8DicbU.Iv-4cK4Od1z_eUXg2mbzvtdDMajU0mLvK7tjLXXeM7yDcR707MX5qMFUor8W00Yw0aUxOniG5mD_L4KPeyiWcxW1JyY9AZivfrnbjcxpvtCkRE2-9L2YoUDyAxl8cGlmS-OC4JT4ACA4XpqR02jQkEmt4c4cIKbsx0FNx5sfD6LYdZgp3shQIMtHlIaf-k3FLNnwtbY8_0PE5rSq33oOhS85vZCRagG5rWVfNXP3w-JErGvdRxJXNqwNm8A5ZL_2tB0Fl3w_D0b8zWK2OaWyisYUmeC1loaGlb5aywuRuDZv63_ix8u527yIdqobt_EraUvJKXKuz3j1GKrBF2-dLA"
        
        authenticator.authenticateUser()
        
        XCTAssert(authenticator.token != nil, "Failed to get a token from SDI backend")
        XCTAssert(authenticator.userID != nil, "Failed to get a unique ID from our backend")

        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
