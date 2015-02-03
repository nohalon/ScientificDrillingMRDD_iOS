//
//  CollectionViewCell.swift
//  UICollectionView
//
//  Created by Brian Coleman on 2014-09-04.
//  Copyright (c) 2014 Brian Coleman. All rights reserved.
//

import UIKit
import QuartzCore


class CollectionViewCell: UICollectionViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let textLabel: UILabel!
    let unitLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let unitFrame = CGRect(x:0, y:0, width: frame.size.width, height: frame.size.height/3)
        unitLabel = UILabel(frame: unitFrame)
        unitLabel.font = UIFont (name: "HelveticaNeue", size: frame.size.height/5)
        //textLabel.layer.borderWidth = 1.0;
        unitLabel.textAlignment = .Center
        
        let textFrame = CGRect(x: 0, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont (name: "HelveticaNeue", size: frame.size.height/2.5)
        //textLabel.layer.borderWidth = 1.0;
        textLabel.textAlignment = .Center
        
        contentView.addSubview(unitLabel)
        contentView.addSubview(textLabel)
    }
}
