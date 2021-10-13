//
//  NoDataCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 2019-11-19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class NoDataCollectionViewCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    let bg = NoTasksBackgroundView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
                      
        contentView.addSubview(bg)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
        
        bg.detailedView?.headerLabel.text = Localization.shared.devices_no_devices
        bg.centerYConstraint?.constant = 0
        bg.detailedView?.mainStack.setCustomSpacing(getCorrectSize(28, 58, 78), after: bg.detailedView!.mainImageView)
        
        bg.detailedView?.subheaderLabel.text = Localization.shared.devices_you_have_no_devices_present_tap_the_plus_sign_top_
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: bg)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: bg)
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setText(forTitle title : String, andSubtitle subtitle : String) {
        bg.detailedView?.headerLabel.text = title
        bg.detailedView?.subheaderLabel.text = subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
