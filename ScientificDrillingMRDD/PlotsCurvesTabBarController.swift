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
    
    override func viewDidLoad() {
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonItemClicked"), animated: true)
    }
    
    func addButtonItemClicked() {
        if (self.selectedIndex == CURVES_NDX) {
            performSegueWithIdentifier("AddCurveSegue", sender: self)
        }
        else if (self.selectedIndex == PLOTS_NDX) {
            println("Open on Plots");
            performSegueWithIdentifier("AddPlotSegue", sender: self)
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