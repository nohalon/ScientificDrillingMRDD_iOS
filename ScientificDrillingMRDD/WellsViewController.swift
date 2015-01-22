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
    @IBOutlet var table: UITableView!
    
    var array : NSArray = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        signOutBtn.addTarget(GPPSignIn.sharedInstance().delegate, action: "logoutApplication", forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wellsMngr.wells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TestCell")
        cell.textLabel?.text = wellsMngr.wells[indexPath.row].name        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell;
    }
    
}

