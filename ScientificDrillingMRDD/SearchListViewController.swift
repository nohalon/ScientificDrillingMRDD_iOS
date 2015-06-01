//
//  SearchListViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 5/31/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation


class SearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBarBtnItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var searchActive : Bool = false
    var data : [String] = []
    var filtered:[String] = []
    var lastIndexPath : NSIndexPath?
    var type : VariableType?
    
    var title_subject = "DV"
    var selected_item : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        self.doneBarBtnItem.enabled = false
        self.navigationItem.title = "Choose an " + title_subject
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        
        if searchActive {
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row]
        }
        
        if let lastIndexPath = self.lastIndexPath {
            if indexPath == lastIndexPath {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                if searchActive {
                    self.selected_item = filtered[indexPath.row]
                } else {
                    self.selected_item = data[indexPath.row]
                }
                self.doneBarBtnItem.enabled = true
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.lastIndexPath = indexPath
        self.tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var dest = segue.destinationViewController as! AddPlotViewController
        
        if let selected = self.selected_item {
            if title_subject == "IV" {
                dest.iv_chosen = selected
            } else {
                dest.dv_chosen = selected
            }
        }
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        performSegueWithIdentifier("unwindToAddPlot", sender: self)
    }
}