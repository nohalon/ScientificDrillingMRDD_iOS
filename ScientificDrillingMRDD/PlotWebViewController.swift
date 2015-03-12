//
//  PlotWebViewController.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 3/4/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import Foundation
import UIKit

class PlotWebViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var plotWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.plotWebView.delegate = self
        self.plotWebView.scrollView.scrollEnabled = true;
        //self.graphWebView.scalesPageToFit = true;
        //NSString *htmlPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"index" ofType:@"html"];
        //[self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[htmlPath stringByDeletingLastPathComponent]]];
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        var path = NSBundle.mainBundle().pathForResource("PlotTest", ofType: "html")!
        
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
        //[self.webView stringByEvaluatingJavaScriptFromString:@"showData([200, 350], ['Blue', 'Crowbar'])"];
        //self.graphWebView.stringByEvaluatingJavaScriptFromString("showData([200, 350], ['Blue', 'Crowbar'])")
        
        var screenRect : CGRect = UIScreen.mainScreen().bounds;
        var screenWidth : CGFloat = self.view.frame.size.width;
        var screenHeight : CGFloat = self.view.frame.size.height;
        
        println("screen width: \(screenWidth) screen height: \(screenHeight)")
        
        var functionCall : String = "InitChart( \(screenWidth), \(screenHeight))"
        self.plotWebView.stringByEvaluatingJavaScriptFromString(functionCall)
        
    }
}