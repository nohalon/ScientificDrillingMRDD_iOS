//
//  AddTableViewCell.swift
//  ScientificDrillingMRDD
//
//  Created by Noha Alon on 3/11/15.
//  Copyright (c) 2015 Noha Alon. All rights reserved.
//

import UIKit

class AddTableViewCell : UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override init() {
        super.init()
    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
