
import Foundation
import UIKit

let PLOTNAME_SECTION = 0
let IV_SECTION = 1
let DV_SECTION = 2
let ADD_CELL_ROW = 0

class AddPlotViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var iv_selected  = false;
    var iv_chosen : String = ""
    var selectedDV: Curve!
    var iVsArry = [""]
    var dVsArry = [""]
    var well : Well!
    var plot : Plot!
    var listPickerView : UIView?
    
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
        return 3;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == PLOTNAME_SECTION {
            return 1
        }
        else if section == IV_SECTION {
            return iVsArry.count
        }
        else if (section == DV_SECTION) {
            return dVsArry.count
        }
        
        return 0;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // insert new row only if you have not yet selected an iv
        if (indexPath.section == IV_SECTION)
        {
            if (iv_selected && indexPath.row == ADD_CELL_ROW) {
                showAlert("IV Selection Notice", message: "You may only select one IV at a time.")
            }
            else if (indexPath.row == 1) {
                println("selected iv cell")
            }
            else {
                self.tableView.beginUpdates()
                self.iVsArry.append("testing")
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.iVsArry.count - 1, inSection: IV_SECTION)], withRowAnimation: UITableViewRowAnimation.Left)
                self.tableView.endUpdates()
            }
        }
        else if (indexPath.section == DV_SECTION) {
            if (iv_selected) {
                self.tableView.beginUpdates()
                self.dVsArry.append("testing")
                
                self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.dVsArry.count - 1, inSection: DV_SECTION)], withRowAnimation: UITableViewRowAnimation.Left)
                self.tableView.endUpdates()
                
            }
            else {
                showAlert("DV Selection Notice", message: "You must select an IV before selecting any DVs.")
            }
        }

    }

    func showAlert(title : String, message : String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Insert) {
            
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == PLOTNAME_SECTION && indexPath.row == ADD_CELL_ROW) {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("nameCell") as! PlotNameInsertCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else if (indexPath.section == IV_SECTION) {
            if (indexPath.row == ADD_CELL_ROW) {
                // style as add button
                let cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as! AddTableViewCell
                cell.customInitIV()
                return cell
            }
            else {
                iv_selected = true;
                var cell = self.tableView.dequeueReusableCellWithIdentifier("ivDvCell") as! IvDvSelectedCell
                
                var iv_list = getIvListFromWell()
                
                //cell = IvDvSelectedCell(view: self.view, iv_list: well.curves.keys.array)
                cell.ivInit(self.view, iv_list: well.curves.keys.array)
                //cell.customInit(self.view, ivDv_list: iv_list)
                listPickerView = cell.getPickerView()
                return cell
            }
        }
        else if (indexPath.section == DV_SECTION) {
            if (indexPath.row == ADD_CELL_ROW) {
                // style as add button
                let cell = self.tableView.dequeueReusableCellWithIdentifier("addCell") as! AddTableViewCell
                cell.customInitDV()
                return cell
            }
            else {
                listPickerView?.hidden = true
                var cell = self.tableView.dequeueReusableCellWithIdentifier("ivDvCell") as! IvDvSelectedCell
                
                var ivCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: IV_SECTION)) as! IvDvSelectedCell
                iv_chosen = ivCell.getCellText()
                //var dv_list = getDvListFromIV(iv_chosen)
                
                //cell = IvDvSelectedCell(view: self.view, dv_list: well.curves[iv_chosen]!)
                cell.dvInit(self.view, dv_list: well.curves[iv_chosen]!)
                listPickerView = cell.getPickerView()
                return cell
            }
        }
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        return cell
    }
    
    func getDvListFromIV(iv: String) -> [String] {
        var dv_list = [String]()
        
        for (ivTemp, curve) in well!.curves {
            if (ivTemp == iv) {
                for data in curve {
                    dv_list.append(data.dv)
                }
            }
        }
        
        return dv_list
    }
    
    func getIvListFromWell() -> [String] {
        var iv_list = [String]()
        
        for (iv, curve) in well!.curves {
            iv_list.append(iv)
        }
        
        return iv_list
    }
    
    func getDvId(iv : String, dv : String) -> String {
        var temp = well!.curves[iv]
        
        for curve in temp! {
            if (curve.dv == dv) {
                return curve.id
            }
        }
        
        return "error"
    }
    
    func getPlotName() -> String {
        var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: PLOTNAME_SECTION)) as! PlotNameInsertCell
        return cell.getPlotName()
    }
    
    @IBAction func doneAddPlotAction(sender: AnyObject) {
        if (iv_chosen != "") {
            var cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: DV_SECTION)) as! IvDvSelectedCell
            //var dv = cell.getCellText()
            //var dvId = getDvId(iv_chosen, dv: dv)
            
            let selectedCurve = cell.selectedDV
            //var curve : Curve = Curve(id: dvId, dv: dv, iv: iv_chosen)
            var plot : Plot = Plot(title: getPlotName(), iv: iv_chosen, curves: [selectedCurve])
            self.plot = plot
            
            well!.plots.append(plot)
            updatePlot(well!.id, plot: plot, onSuccess: onSuccess)
        }
    }
    
    // Extract and override
    func updatePlot(wellID: String, plot: Plot, onSuccess: () -> Void) {
        wellsMngr.updatePlot(wellID, plot: plot, onSuccess: onSuccess)
    }
    
    func onSuccess() {
        performSegueWithIdentifier("PlotsTabBarSegue", sender: self)
    }
}

class AddTableViewCell : UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func customInitIV() {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        label.text = "Add an Independent Variable"
    }
    
    func customInitDV() {
        self.selectionStyle = UITableViewCellSelectionStyle.None
        label.text = "Add a Dependent Variable"
    }
}

class PlotNameInsertCell : UITableViewCell {
    @IBOutlet weak var plotNameInput: UITextField!
    
    func getPlotName() ->String {
        return plotNameInput.text
    }
}

class IvDvSelectedCell : UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var elmt_selected: UITextField!
    var ivPickerArray: [String]!
    var dvPickerArray: [Curve]!
    var selectedIV: String!
    var selectedDV: Curve!
    var view : UIView!
    var listPicker : UIPickerView = UIPickerView()
    var pickerView : UIView = UIView()
    
    func getCellText() -> String {
        return elmt_selected.text
    }
    
    /*func customInit(view : UIView, iv_list: [String]) {
    }*/
    
    func ivInit(view: UIView, iv_list: [String]) {
        //super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        self.view = view
        self.ivPickerArray = iv_list
        self.dvPickerArray = nil
        self.selectionStyle = UITableViewCellSelectionStyle.None
        elmt_selected.text = ivPickerArray[0];
        openPickerView()
    }

    func dvInit(view: UIView, dv_list: [Curve]) {
        //super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        self.view = view
        self.dvPickerArray = dv_list
        self.ivPickerArray = nil
        self.selectionStyle = UITableViewCellSelectionStyle.None
        elmt_selected.text = dvPickerArray[0].dv
        openPickerView()       
    }
    
    func openPickerView() {
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var width:CGFloat = bounds.size.width
        var height:CGFloat = bounds.size.height
        
        pickerView = UIView(frame: CGRectMake(0, height - 260, width, 300))
        
        var toolbar : UIToolbar = UIToolbar(frame: CGRectMake(0, 0, width, 44))
        toolbar.barStyle = UIBarStyle.Default
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "dismissUIView")
        toolbar.setItems([doneButton], animated: true)
        
        var dim = CGRectMake(0, 0, width, 300)
        
        listPicker = UIPickerView(frame: dim);
        listPicker.backgroundColor = UIColor.whiteColor()
        listPicker.delegate = self;
        listPicker.showsSelectionIndicator = true
    
        pickerView.addSubview(listPicker)
        pickerView.addSubview(toolbar)
        
        view.addSubview(pickerView)
        view.bringSubviewToFront(pickerView)
        
        elmt_selected.inputView = listPicker
    }
    
    func getPickerView() -> UIView {
        return pickerView
    }
    
    func dismissUIView() {
        pickerView.hidden = true
    }
    
    func numberOfComponentsInPickerView(colorPicker: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let picker = ivPickerArray {
            return picker.count
        } else {
            return dvPickerArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var title = ""
        if let picker = dvPickerArray {
            let rowCurve: Curve = picker[row]
            title += rowCurve.dv
        } else {
            title += ivPickerArray[row]
        }
        
        return title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var text = ""
        if let picker = dvPickerArray {
            let rowCurve: Curve = picker[row]
            text += rowCurve.dv
            selectedDV = rowCurve
        } else {
            text += ivPickerArray[row]
            selectedIV = ivPickerArray[row]
        }       
        elmt_selected.text = text;
    }
    
}


