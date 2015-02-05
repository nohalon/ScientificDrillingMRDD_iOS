//
//  WellsViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

class WellsViewController: UIViewController {
    
    //@IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet var table: UITableView!
    
    var array : NSArray = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationBar.translucent = false
        
        //signOutBtn.addTarget(GPPSignIn.sharedInstance().delegate, action: "logoutApplication", forControlEvents: .TouchUpInside)
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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        cell.textLabel?.text = wellsMngr.wells[indexPath.row].name        
        
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.index = indexPath.row
        
        self.performSegueWithIdentifier("DashboardSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DashboardSegue" {
            var dashboard = segue.destinationViewController as WellsDashboardController
            dashboard.well = wellsMngr.wells[index]
            
            //= wellsMngr.wells[index].name
        }
    }
    
}

