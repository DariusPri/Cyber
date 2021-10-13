//
//  TitleLabelSectionHeader.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class TitleLabelSectionCell: UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Bold", size: 12)
        label.textColor = UIColor(named: "dataSectionTitleColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var widthConstraint : NSLayoutConstraint?
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        widthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
                
        containerView.addSubview(titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: titleLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: titleLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
