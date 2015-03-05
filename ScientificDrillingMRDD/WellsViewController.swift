//
//  WellsViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 1/21/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

let SETTINGS_NDX = 0
let LOGOUT_NDX = 1

class WellsViewController: UIViewController, SideBarDelegate {
    
    @IBOutlet var table: UITableView!
    
    var sideBar : SideBar = SideBar()
    var array : NSArray = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true;
        self.navigationController?.navigationBar.translucent = false
        
        sideBar = SideBar(sourceView: self.view, menuItems: config.getProperty("sideBarMenuItems") as [String])
        sideBar.delegate = self
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
        
        self.performSegueWithIdentifier("TabBarSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TabBarSegue" {
            var dashboard = segue.destinationViewController as UITabBarController
            
            var destinationViewController = dashboard.viewControllers?.first as WellsDashboardController // or whatever tab index you're trying to access
            
            //var destinationViewController = segue. as WellsDashboardController
            destinationViewController.well = wellsMngr.wells[index]
            //test.well = wellsMngr.wells[index]
        }
    }
    
    @IBAction func menuBarAction(sender: AnyObject) {
        if sideBar.isSideBarOpen {
            sideBar.showSideBar(false)
        }
        else {
            sideBar.showSideBar(true)
        }
    }
    
    func didSelectButtonAtIndex(index : Int) {
        if index == SETTINGS_NDX {
            // Settings
        }
        else if index == LOGOUT_NDX {
            // log
            self.performSegueWithIdentifier("LogoutSegue", sender : self)
            
        }
    }
    
}

