//
//  WellsViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

class WellsViewController: UIViewController {
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        signOutBtn.addTarget(GPPSignIn.sharedInstance().delegate, action: "logoutApplication", forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

