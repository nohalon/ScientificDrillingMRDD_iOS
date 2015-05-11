import Foundation
import UIKit

class PlotWebViewController : UIViewController, UIWebViewDelegate {
    let log = Logging()

    @IBOutlet weak var plotWebView: UIWebView!
    var plot : Plot?
    var well : Well?
    var plotName : String!
    
    override func viewWillAppear(animated: Bool) {
        plotName = plot?.title
        self.title = plotName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plotWebView.delegate = self
        self.plotWebView.scrollView.scrollEnabled = false;
    }
    
    @IBAction func refreshPlotAction(sender: AnyObject) {
        log.DLog("\(NSDate()): refresh the plot with new data.", function: "refreshPlotAction")
        wellsMngr.updatePlot(well!.id, plot: plot!)
        self.plotWebView.reload()
    }
    
    override func viewDidAppear(animated: Bool) {
        var path = NSBundle.mainBundle().pathForResource("ScrollPlot", ofType: "html")!
        
        var html = NSString(contentsOfFile: path, usedEncoding: nil, error: nil)
        var url = NSURL(fileURLWithPath: path)
        self.plotWebView.loadHTMLString(html as! String, baseURL: url)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadWebView()
    }
    
    func loadWebView() {
        var screenRect : CGRect = UIScreen.mainScreen().bounds;
        var screenWidth : CGFloat = self.view.frame.size.width;
        var screenHeight : CGFloat = self.view.frame.size.height;
        
        var ivName : String? = plot?.curves[0].iv_units
        var dvName : String? = plot?.curves[0].dv_units
        
        log.DLog("\(NSDate()): load plot with screen width: \(screenWidth) screen height: \(screenHeight).", function: "loadWebView")
        
        var lineData = formatCurve()
        var functionCall : String = "InitChart(\(lineData), \(screenWidth), \(screenHeight))"
        
        self.plotWebView.stringByEvaluatingJavaScriptFromString(functionCall)
    }
    
    func formatCurve() -> String {
        
        var jsonStr : String = "["
    
        if let lineData = plot?.curves[0].values {
            for (x, y) in lineData {
                jsonStr += "{'x': \(x), 'y': \(y)},"
            }
            jsonStr = jsonStr.substringToIndex(jsonStr.endIndex.predecessor())
            jsonStr += "]"
        }
        else
        {
            log.DLog("\(NSDate()): Error with loading curve values.", function: "formatCurve")
        }
        
        return jsonStr
    }
}