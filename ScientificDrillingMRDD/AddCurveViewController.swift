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
    
    var wellName : String?
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
        var curveCount = 0;
        if let name = wellName? {
            curveCount = curveMngr.curves[name]!.count
        }
        else {
            
        }
        return curveCount
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        
        if let name = wellName? {
            cell.textLabel?.text = curveMngr.curves[name]![indexPath.row]
        }
        else {
            
        }
        
        return cell;
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.index = indexPath.row
        
        if let name = wellName? {
            self.selectedCurve = curveMngr.curves[name]![index]
        }
        else {
            
        }
        
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
