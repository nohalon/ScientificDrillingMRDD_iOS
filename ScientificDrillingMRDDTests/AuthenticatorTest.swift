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

class AuthenticatorTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        let vc : LoginWebViewController = LoginWebViewController()
        //let wellsMngr = WellsManager()
        //wellsMngr.loadWells()
        
        let authenticator = Authenticator(controller: vc)
        
        // Need to programmatically get the code using a script
        authenticator.code = "bME6zdyD7kSdduzCBTTQUg.Y-u6n98o0ggIAQ5N8F6nRAAZ_uU.Tf6yuF_IMOwDmL4RuyZoekb6xYg1uot74dDVFI_Wxp5zMIQfwKmaOKcIQM3e-oJVIBZ66nQVSPFkr9Avj4jN7RLqEuPVPJoediSudLkrkntmT4uN2u0wYZuhgYA0snecttIenkgSKqjyXxXmkKhrbjJweqPzQodvxo45QkAiDPsvk8PUGa9gBf83XB98lRGfcTGUercq3w9h2lQ89D2Hq3MOd_mKR7puyQ9vS-T2PPqPtsUyHHEAhAa5ONlkOCUzhELICUne41CH8RMHN7Pu1OuE2Ldt97N9M7rklZfW7ZQwyg4momYy-46InWSZ4TgVe6sQMdADPnzJyK0wuYPQ5A"
        
        authenticator.authenticateUser()
        sleep(1)
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
