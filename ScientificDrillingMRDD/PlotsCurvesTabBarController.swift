//
//  PlotsCurvesTabBarController.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 3/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation

let CURVES_NDX = 0
let PLOTS_NDX = 1

class PlotsCurvesTabBarController : UITabBarController {
    
    var well : Well?
    var plusButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        plusButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonItemClicked")
        self.navigationItem.setRightBarButtonItem(plusButton, animated: true)
    }
    
    func addButtonItemClicked() {
        if well!.curves.count > 0 {
            if (self.selectedIndex == CURVES_NDX) {
                performSegueWithIdentifier("AddCurveSegue", sender: self)
            }
            else if (self.selectedIndex == PLOTS_NDX) {
                println("Open on Plots");
                performSegueWithIdentifier("AddPlotSegue", sender: self)
            }
        } else {
            let alertController = UIAlertController(title: "Add Notification", message: "Curves haven't been loaded yet", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "AddCurveSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            var addCurveController = navigationController.topViewController as! AddCurveViewController
            addCurveController.well = well
        }
        else if (segue.identifier == "AddPlotSegue") {
            let navigationController = segue.destinationViewController as! UINavigationController
            var addPlotController = navigationController.topViewController as! AddPlotViewController
            addPlotController.well = well
        }
    }
    
    @IBAction func unwindToTabBar(segue: UIStoryboardSegue) {

    }
}