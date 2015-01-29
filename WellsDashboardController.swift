import UIKit
import Foundation

class WellsDashboardController : UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var wellName = "some-name"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = wellName;
        
    }
    
}