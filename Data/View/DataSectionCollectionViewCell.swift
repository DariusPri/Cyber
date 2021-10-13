//
//  DataSectionCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 2019-07-03.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class DataSectionCollectionViewCell: UICollectionViewCell {
    
    let radioView = RadioButtonView(frame: .zero)
    var widthConstraint : NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(radioView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: radioView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: radioView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
