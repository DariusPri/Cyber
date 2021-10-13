//
//  SettingsProfileSectionHeader.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SettingsProfileSectionHeader: UICollectionReusableView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "defaultTextColor")
        label.font = UIFont(name: "Muli-Regular", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Troy Stanley"
        return label
    }()
    
    let currentPlanLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "defaultTextColor")
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Standard Plan"
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(20, 20, 26))
        currentPlanLabel.font = currentPlanLabel.font.withSize(getCorrectSize(13, 13, 17))
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, currentPlanLabel])
        stack.alignment = .center
        stack.axis = .vertical
        stack.setCustomSpacing(getCorrectSize(5, 5, 7), after: titleLabel)
        stack.setCustomSpacing(getCorrectSize(10, 10, 15), after: currentPlanLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        currentPlanLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: stack)
        addConstraintsWithFormat(format: "V:|[v0]", views: stack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
