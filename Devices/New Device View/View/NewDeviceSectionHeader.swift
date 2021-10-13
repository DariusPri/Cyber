//
//  NewDeviceSectionHeader.swift
//  Xpert
//
//  Created by Darius on 30/11/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class NewDeviceSectionHeader: UICollectionReusableView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(optionalLabel)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(12, 12, 16))
        optionalLabel.font = optionalLabel.font.withSize(getCorrectSize(12, 12, 16))
        
        addConstraintsWithFormat(format: "H:|-15-[v0]-\(getCorrectSize(10, 10, 14))-[v1]-(>=10)-|", views: titleLabel, optionalLabel)
        addConstraintsWithFormat(format: "V:|[v0]", views: titleLabel)
        
        NSLayoutConstraint(item: optionalLabel, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    lazy var optionalLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 12)
        label.text = "("+Localization.shared.add_optional+")"
        label.textColor = .lightGray
        return label
    }()
    
    func addOptional(with value : Bool) {
        optionalLabel.isHidden = !value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


