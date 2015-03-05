import UIKit
import Foundation

class WellsDashboardController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    let log = Logging()
    
    let DEGREE_SIGN = "\u{00B0}"
    let SIDE_PADDING : CGFloat = 10
    let TOP_PADDING : CGFloat = 20
    let BOTTOM_PADDING : CGFloat = 10
    
    @IBOutlet var collectionView: UICollectionView!
    
    var well: Well = Well(id: "", name: "NoWell")
    var myTimer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = well.name;
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: TOP_PADDING, left: SIDE_PADDING, bottom: BOTTOM_PADDING, right: SIDE_PADDING)
        layout.itemSize = CGSize(width: (self.view.frame.width - 3 * SIDE_PADDING) / 2 , height: 50)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        dashMngr.loadDashboardForWell(well.name)
    }
    
    func update() {
        // TODO: Animations - http://stackoverflow.com/questions/14804359/uicollectionview-doesnt-update-immediately-when-calling-reloaddata-but-randoml
        dashMngr.loadDashboardForWell(well.name)
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
        if let dash = dashMngr.dashboards[well.name] {
            items = dash.dataVisualizations.count
        }
        else {
            items = 0
        }
        return items!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as CollectionViewCell
        cell.layer.borderWidth = 1.0
        var dashboard = dashMngr.dashboards[well.name]
        var visualization = dashboard?.dataVisualizations[indexPath.row]
        
        var unitResult : String? = visualization?.label
        
        var valueResult = String(format: "%.2f", (visualization?.currentValue)!)
        var unit : String?
        
        switch unitResult! {
        case "Temperature":
            unit = " " + DEGREE_SIGN + "F"
        case "Depth":
            unit = " m"
        case "Time":
            unit = " s"
        default:
            self.log.DLog("ERROR: Invalid unit found", function: "collectionView")
            break
        }
        cell.unitLabel?.text = visualization?.label
        cell.textLabel?.text = valueResult + unit!
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCurveSegue" {
            let navigationController = segue.destinationViewController as UINavigationController
            var addCurveController = navigationController.topViewController as AddCurveViewController
            
            addCurveController.wellName = well.name
        }
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectCurveSegue" {
            let addCurveController = segue.sourceViewController as AddCurveViewController
            
            if let selected = addCurveController.selectedCurve {
                dashMngr.dashboards[well.name]?.addVisualization(VisualizationType.StaticValue, id: 1, name: selected)
            }
            
            dashMngr.loadDashboardForWell(well.name)
            self.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}