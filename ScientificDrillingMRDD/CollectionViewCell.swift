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
    var textLabel: UILabel = UILabel()
    var unitLabel: UILabel = UILabel()
    var timeLabel: UILabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let unitFrame = CGRect(x:0, y:0, width: frame.size.width, height: frame.size.height/3)
        self.unitLabel = UILabel(frame: unitFrame)
        unitLabel.font = UIFont (name: config.getProperty("collectionViewCellFont") as! String, size: frame.size.height/5)
        unitLabel.textAlignment = .Center
        
        let textFrame = CGRect(x: 0, y: frame.size.height/2 - 4, width: frame.size.width, height: frame.size.height/2)
        self.textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont (name: config.getProperty("collectionViewCellFont") as! String, size: frame.size.height/2.5)
        textLabel.textAlignment = .Center
        
        let timeFrame = CGRect(x: 0, y: frame.size.height/4, width: frame.size.width, height: frame.size.height/3)
        self.timeLabel = UILabel(frame: timeFrame)
        timeLabel.font = UIFont (name: config.getProperty("collectionViewCellFont") as! String, size: frame.size.height/6)
        timeLabel.textAlignment = .Center
        
        contentView.addSubview(unitLabel)
        contentView.addSubview(textLabel)
        contentView.addSubview(timeLabel)
    }
}
