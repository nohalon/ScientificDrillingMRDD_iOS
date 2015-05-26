import UIKit
import Foundation

class WellsDashboardController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let log = Logging()

    let SIDE_PADDING : CGFloat = 10
    let TOP_PADDING : CGFloat = 20
    let BOTTOM_PADDING : CGFloat = 10
    
    @IBOutlet var collectionView: UICollectionView!
    
    var well: Well = Well(id: "", name: "NoWell")
    var myTimer : NSTimer?
    var availableCurves = [String: [Curve]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = self.tabBarController as! PlotsCurvesTabBarController
        tabBar.title = well.name;
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING, bottom: BOTTOM_PADDING, right: SIDE_PADDING)
        layout.itemSize = CGSize(width: (self.view.frame.width - 3 * SIDE_PADDING) / 2 , height: 60)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        initAvailableCurves()
        
        tabBar.dashboardCurves = availableCurves
        wellsMngr.updateDashboardForWell(well)
    }

    func initAvailableCurves() {
        for key in well.curves.keys {
            availableCurves[key] = [Curve]()
            for curve in well.curves[key]! {
                let staticDVs = well.dashboard.staticNumberDV.filter({(dv: DataVisualization) -> Bool in
                    return dv.curve.id == curve.id
                })
                
                if staticDVs.count == 0 {
                    availableCurves[key]!.append(Curve(id: curve.id, dv: curve.dv, iv: curve.iv, wellbore: curve.wellbore_id))
                }
            }
        }
    }
    
    func update() {
        wellsMngr.updateDashboardForWell(well)
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        myTimer!.invalidate()
    }
    
    override func viewWillAppear(animated: Bool) {
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var items: Int?
        
        items = well.dashboard.staticNumberDV.count
        
        return items!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.layer.borderWidth = 1.0
        
        var visualization = well.dashboard.staticNumberDV[indexPath.row]
        var unitResult : String = visualization.curve.dv
        var valueResult = String(format: "%.2f", visualization.curve.lastValue.0)
        cell.timeLabel.text = timeSince(visualization.curve)
        
        cell.textLabel.alpha = 1.0
        
        if visualization.curve.dv_units == "" && valueResult == "0.00" {
            valueResult = "No Values"
            cell.timeLabel.text = ""
            cell.textLabel.alpha = 0.3
        } else if let wellbore = visualization.curve.wellbore_id {
            cell.timeLabel.text = wellboreCurveLabel(visualization)
        }
        cell.unitLabel.text = unitResult
        cell.textLabel.text = "\(valueResult) \(visualization.curve.dv_units)"
        return cell
    }
    
    func wellboreCurveLabel(visualization : DataVisualization) -> String {
        var returnString : String
        switch visualization.curve.iv {
        case "Vertical Section":
            returnString = "VS: \(visualization.curve.lastValue.1) \(visualization.curve.iv_units)"
        case "True Vertical Depth":
            returnString = "TVD: \(visualization.curve.lastValue.1) \(visualization.curve.iv_units)"
        case "Measured Depth":
            returnString = "MS: \(visualization.curve.lastValue.1) \(visualization.curve.iv_units)"
        default :
            returnString = ""
        }
        return returnString
    }
    
    func timeSince(curve : Curve) -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        let timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = timeZone
        
        let epochTime : String = String(stringInterpolationSegment: curve.lastValue.1)
        let epochSeconds : NSTimeInterval = (epochTime as NSString).doubleValue
        let thenNSDate : NSDate = NSDate(timeIntervalSince1970: epochSeconds)
        
        let difference = NSInteger(date.timeIntervalSinceDate(thenNSDate))
        //let diffNSDate : NSDate = NSDate(timeIntervalSinceNow: difference)
        
        var seconds = difference % 60
        var minutes = (difference / 60) % 60
        var hours = (difference / 3600) % 24
        var days = (difference / 86400)
        
        
        return NSString(format: "Age : %0.2d days %0.2d:%0.2d:%0.2d",days, hours,minutes,seconds) as String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCurveSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            var addCurveController = navigationController.topViewController as! AddCurveViewController
            
            addCurveController.well = well
            addCurveController.availableCurves = availableCurves
        }
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectCurveSegue" {
            let addCurveController = segue.sourceViewController as! AddCurveViewController
            
            if let selected = addCurveController.selectedCurve {
                well.dashboard.addVisualization(.StaticValue, curve: selected)
                removeCurveFromAvailable(selected)
            }
            
            wellsMngr.updateDashboardForWell(well)
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeCurveFromAvailable(curve: Curve) {
        let curveType = curve.iv
        if let curveList = availableCurves[curveType] {
            for curveIdx in 0...curveList.count - 1 {
                if curveList[curveIdx].id == curve.id {
                    availableCurves[curveType]!.removeAtIndex(curveIdx)
                }
            }
        }
    }
    
    func removeItemFromArray(item : Curve, inout list : [Curve]) -> [Curve] {
        for var ndx = 0; ndx < list.count; ndx++ {
            if item.id == list[ndx].id {
                list.removeAtIndex(ndx)
            }
        }
        return list
    }   
}