
import Foundation
import UIKit

let PLOTNAME_SECTION = 0
let IV_SECTION = 1
let DV_SECTION = 2

class AddPlotViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var plotName: UITextField!

    var iv_selected  = false;
    
    var dvsArry = ["hello"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let ct = self.tableView(tableView, numberOfRowsInSection:indexPath.section)
        
        if indexPath.section == 1 {
            return .Insert
        }
        return .None
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (!iv_selected)
        {
            return 2;
        }
        
        return 3;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == PLOTNAME_SECTION {
            return 1
        }
        else if section == IV_SECTION {
            return dvsArry.count
        }
        else if (section == DV_SECTION) {
            return 3
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 1)
        {
            self.tableView.beginUpdates()
            self.dvsArry.append("new")
            

            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.dvsArry.count - 1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Left)
            self.tableView.endUpdates()
        }

    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Insert) {
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            // style as add button
            let cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as! AddTableViewCell
            return cell
        }
        else if (indexPath.section == 0 && indexPath.row == 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("nameCell") as! PlotNameInsertCell
            return cell
        }
        else if (indexPath.section == IV_SECTION && indexPath.row != 0) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ivCell") as! IVSelectedCell
            cell.openPickerView(self.view)
            return cell
        }
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        return cell
    }
    
    @IBAction func doneAddPlotAction(sender: AnyObject) {
        
    }
    
    @IBAction func cancelAddPlotAction(sender: AnyObject) {
    }
}

class AddTableViewCell : UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
}

class PlotNameInsertCell : UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plotNameInput: UITextField!
}

class IVSelectedCell : UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var iv_selected: UITextField!
    var listPickerArray = ["testing 1", "testing 2", "testing 3", "testing 4"]
    var listPicker : UIPickerView = UIPickerView()
    var pickerView : UIView = UIView();
    
    
    func openPickerView(view : UIView) {
        pickerView =  UIView(frame: CGRectMake(0, view.frame.size.height/2, view.frame.size.width, 400))
        
        var toolbar : UIToolbar = UIToolbar(frame: CGRectMake(0,0,view.bounds.width,44))
        toolbar.barStyle = UIBarStyle.Default
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "donePressed")
        toolbar.setItems([doneButton], animated: true)
        
        var dim = CGRectMake(0, toolbar.frame.size.height, toolbar.frame.size.width, 100)
        listPicker = UIPickerView(frame: dim);
        listPicker.delegate = self;
        listPicker.showsSelectionIndicator = true
        
        pickerView.addSubview(toolbar)
        pickerView.addSubview(listPicker)
        
        view.addSubview(pickerView)
        view.bringSubviewToFront(pickerView)
        
        iv_selected.inputView = listPicker
    }
    
    func donePressed() {
        println("done touched")
        pickerView.hidden = true
    }
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listPickerArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return listPickerArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        iv_selected.text = listPickerArray[row];
    }
    
}


