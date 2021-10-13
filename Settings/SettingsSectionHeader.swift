//
//  SettingsSectionHeader.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public class SettingsSectionHeader: UICollectionReusableView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Bold", size: 12)
        label.textColor = UIColor(named: "defaultTextColor")
        return label
    }()
    
    var leftConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(12, 12, 17))
        leftConstraint = NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 30)
        leftConstraint?.isActive = true
        addConstraintsWithFormat(format: "V:|-\(getCorrectSize(25, 25, 38))-[v0]", views: titleLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class InputHeaderView : SettingsSectionHeader {
    
    let optionalLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.text = "(optional)"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        optionalLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(optionalLabel)
        NSLayoutConstraint(item: optionalLabel, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 5).isActive = true
        NSLayoutConstraint(item: optionalLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: -1).isActive = true
        leftConstraint?.constant = 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
