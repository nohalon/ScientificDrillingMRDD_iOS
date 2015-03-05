//
//  WellsPlotViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 3/3/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

class WellsPlotViewController : UIViewController {
    
    @IBOutlet var plotsListTable: UITableView!
    
    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        plotsListTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        cell.textLabel?.text = "Testing Plot"
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("PlotWebViewSegue", sender: self)
    }
}