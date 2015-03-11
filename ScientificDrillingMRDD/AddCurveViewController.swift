//
//  AddCurveViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Justine Dunham on 2/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

// View Controller for selecting a curve from a list to add to a selected well's dashboard
class AddCurveViewController: UITableViewController {
    let log = Logging()
    
    @IBOutlet var curveTable: UITableView!
    
    // Selected Well
    var well : Well?
    // Curve ID
    var selectedCurve: Curve?
    
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
    
    // Returns number of rows in a section (number of curves)
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var curveCount = 0;
        
        if let selectedWell = well? {
            curveCount = selectedWell.curves["Time"]!.count
        }
        else {
            log.DLog("No well selected", function: "tableView")
        }
        
        return curveCount
    }
    
    // Returns a cell for an index, with label set to the appropriate curve's name
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        
        if let selectedWell = well? {
            cell.textLabel?.text = selectedWell.curves["Time"]![indexPath.row].dv
        }
        else {
            log.DLog("No well selected", function: "tableView")
        }
        
        return cell;
    }
    
    // Sets the selected curve to the name of the selected curve and segues back to the dashboard
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        if let selectedWell = well? {
            self.selectedCurve = selectedWell.curves["Time"]![index]
        }
        else {
            log.DLog("No well selected", function: "tableView")
        }
        
        self.performSegueWithIdentifier("SelectCurveSegue", sender: self)
    }
    
    // Cancel goes back to dashboard
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

