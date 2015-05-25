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
    // Available curves for selection
    var availableCurves: [String: [Curve]]?
    // Headers
    var headers = [UIView]()
    // Keep track of collapsed sections
    var isCollapsed = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let available = availableCurves {
            let keys = available.keys.array
            for idx in 0...keys.count - 1 {
                //headers.append(view!)
                isCollapsed.append(false)
                headers.append(UIView())
            }
        }
    }

    func headerTapped(sender: UITapGestureRecognizer) {
        let idx = sender.view?.tag
        isCollapsed[idx!] = !isCollapsed[idx!]
        curveTable!.reloadData()
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
        
        /*if let selectedWell = well {
            curveCount = selectedWell.removeAddedCurves().count
        }*/
        
        if !isCollapsed[section] {
            if let available = availableCurves {
                let keys = available.keys
                let sectionKey: String? = keys.array[section]
                curveCount = available[sectionKey!]!.count
            }
            else {
                log.DLog("No well selected", function: "tableView")
            }
        }
        
        return curveCount
    }
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let available = availableCurves {
            return available.keys.array.count
        } else {
            return 0
        }
    }
   
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let view = super.tableView(tableView, viewForHeaderInSection: section)
   
        var view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 18))

        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "headerTapped:")
        view.addGestureRecognizer(gesture)
        view.tag = section
        view.backgroundColor = UIColor.grayColor()
        
        /* Create custom view to display section header... */
        var label = UILabel(frame: CGRectMake(10, 5, tableView.frame.size.width, 18))
        label.font = UIFont.boldSystemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        /* Section header is in 0th index... */
        label.text = getTitleForSection(section)
        label.textAlignment = NSTextAlignment.Left
        view.addSubview(label)
        
        headers[section] = view
        
        return view
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTitleForSection(section)
    }
    
    private func getTitleForSection(section: Int) -> String {
        var headerText: String = ""
        
        if let available = availableCurves {
            let keys = available.keys
            let sectionKey: String? = keys.array[section]
            headerText = sectionKey!
        }
        return headerText
    }
    
    // Returns a cell for an index, with label set to the appropriate curve's name
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "WellCell")
        
        /*if let selectedWell = well {
            cell.textLabel?.text = selectedWell.removeAddedCurves()[indexPath.row].dv
        }*/
        if let available = availableCurves {
            let keys = available.keys.array
            let sectionKey: String? = keys[indexPath.section]
            cell.textLabel?.text = available[sectionKey!]![indexPath.row].dv
        }
        else {
            log.DLog("No well selected", function: "tableView")
        }
        
        return cell;
    }

    
    // Sets the selected curve to the name of the selected curve and segues back to the dashboard
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
        
        /*if let selectedWell = well {
            self.selectedCurve = selectedWell.removeAddedCurves()[index]
        }*/
        if let available = availableCurves {
            let keys = available.keys
            let sectionKey: String? = keys.array[indexPath.section]
            self.selectedCurve = available[sectionKey!]![indexPath.row]
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