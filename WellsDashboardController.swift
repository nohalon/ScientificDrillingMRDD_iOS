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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.title = well.name;
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING, bottom: BOTTOM_PADDING, right: SIDE_PADDING)
        layout.itemSize = CGSize(width: (self.view.frame.width - 3 * SIDE_PADDING) / 2 , height: 60)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        wellsMngr.updateDashboardForWell(well)
        
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
        cell.unitLabel.text = unitResult
        cell.textLabel.text = "\(valueResult) \(visualization.curve.dv_units)"
        cell.timeLabel.text = timeSince(visualization.curve)
        return cell
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
        var hours = (difference / 3600)
        
        return NSString(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds) as String
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCurveSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            var addCurveController = navigationController.topViewController as! AddCurveViewController
            
            addCurveController.well = well
        }
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectCurveSegue" {
            let addCurveController = segue.sourceViewController as! AddCurveViewController
            
            if let selected = addCurveController.selectedCurve {
                well.dashboard.addVisualization(.StaticValue, curve: selected)
            }
            
            wellsMngr.updateDashboardForWell(well)
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}