//
//  SectionHeaderView.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    let sectionHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(named: "dashboardSectionTextColor")
        return label
    }()
    
    var leftConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addBorder(top: true)
        addBorder(top: false)
        
        sectionHeaderLabel.font = sectionHeaderLabel.font.withSize(getCorrectSize(12, 12, 14))
        
        addSubview(sectionHeaderLabel)
        addConstraintsWithFormat(format: "H:[v0]-30-|", views: sectionHeaderLabel)
        leftConstraint = NSLayoutConstraint(item: sectionHeaderLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 30)
        leftConstraint?.isActive = true
        NSLayoutConstraint(item: sectionHeaderLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true 
    }
    
    func addBorder(top : Bool) {
        let separator : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "dashboardSectionBorderColor")
            view.heightAnchor.constraint(equalToConstant: getCorrectSize(0.4, 0.4, 0.6)).isActive = true 
            return view
        }()
        addSubview(separator)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separator)
        if top == true { addConstraintsWithFormat(format: "V:|[v0]", views: separator) } else { addConstraintsWithFormat(format: "V:[v0]|", views: separator) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
