//
//  AddCurveViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class AddCurveViewController: UITableViewController {
    
    @IBOutlet var curveTable: UITableView!
    
    var curveList = [String]()
    var selectedCurve: String?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        curveTable.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curveList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        cell.textLabel?.text = curveList[indexPath.row]
        
        return cell;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.index = indexPath.row
        self.selectedCurve = curveList[index]
        
        self.performSegueWithIdentifier("SelectCurveSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectCurveSegue" {
            //var dashboard = segue.destinationViewController as WellsDashboardController
            //dashboard.well = wellsMngr.wells[index]
            
            //= wellsMngr.wells[index].name
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
