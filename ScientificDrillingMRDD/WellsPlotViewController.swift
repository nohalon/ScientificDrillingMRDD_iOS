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
    var plots = [Plot]()
    var well : Well?
    var selectedPlot : Int?

    override func viewDidLoad() {
    }
    
    override func viewWillAppear(animated: Bool) {
        plotsListTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plots.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        cell.textLabel?.text = plots[indexPath.row].title
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPlot = indexPath.row
        self.performSegueWithIdentifier("PlotWebViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "PlotWebViewSegue")
        {
            var destinationViewController = segue.destinationViewController as! PlotWebViewController
            destinationViewController.plot = plots[selectedPlot!]
            destinationViewController.well = self.well
        }
    }
    
    @IBAction func unwindToPlotsTabBar(segue: UIStoryboardSegue) {
        if (segue.identifier == "PlotsTabBarSegue")
        {
            var source = segue.sourceViewController as! AddPlotViewController
            if let item: Plot = source.plot {
                self.well = source.well
                self.plots.append(item)
                self.plotsListTable.reloadData()
            }
        }
        
    }
}