import UIKit
import Foundation

class WellsDashboardController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let DEGREE_SIGN = "\u{00B0}"
    let SIDE_PADDING : CGFloat = 10
    let TOP_PADDING : CGFloat = 20
    let BOTTOM_PADDING : CGFloat = 10

    @IBOutlet var collectionView: UICollectionView!
    
    var well: Well = Well(id: -1, name: "NoWell")
    
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
        
        dashMngr.loadDashboard(well.name)
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
        
        cell.unitLabel?.text = visualization?.label
        cell.textLabel?.text = "\(visualization?.currentValue)"
        
        return cell
    }
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCurveSegue" {
            let navigationController = segue.destinationViewController as UINavigationController
            var addCurveController = navigationController.topViewController as AddCurveViewController

            var urlString = "http://127.0.0.1:5000/getCurvesForWell?well=" + well.name
            urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var url = NSURL(string: urlString)
        
            // Opens session with server
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }

                var err: NSError?
            
                if let jsonResult: AnyObject = NSJSONSerialization.JSONObjectWithData(data,options:nil,error: nil) {
                    if jsonResult is NSArray {
                    
                        for x in jsonResult as NSArray {
                            addCurveController.curveList.append(x as String)
                        }
                    }
                    else {
                        println("jsonResult was not an NSArray")
                    }
                }
            
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
            })
        
            task.resume()
            
        }
    }
   
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {
        if segue.identifier == "SelectCurveSegue" {
            let addCurveController = segue.sourceViewController as AddCurveViewController
            
            if let selected = addCurveController.selectedCurve {
                dashMngr.dashboards[well.name]?.addVisualization(VisualizationType.StaticValue, id: 1, name: selected)
            }
            
            dashMngr.loadDashboard(well.name)
            self.collectionView.reloadData()
        }
        
        if let dashboard = dashMngr.dashboards[well.name] {
            //dashboard.printDashboard()
            // Jonathan: I'm printing the dashboard after we request the data in DashBoardManager.swift 
        }
        else {
            println("No data visualizations added")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}