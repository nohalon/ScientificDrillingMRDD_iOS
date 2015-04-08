
import UIKit
import Foundation

class Plot : NSObject {
    var title : String
    var iv : String
    var curves : [Curve]
    
    init (title : String, iv : String) {
        self.title = title;
        self.iv = iv;
        self.curves = [Curve]();
    }
    
    init (title : String, iv : String, curves : [Curve]) {
        self.title = title;
        self.iv = iv;
        self.curves = curves;
    }
}