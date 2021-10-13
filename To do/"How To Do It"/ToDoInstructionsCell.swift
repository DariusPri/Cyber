//
//  ToDoInstructionsCell.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoInstructionsCell: UICollectionViewCell {
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 20)
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Sample Text Here!"
        return label
    }()
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        textLabel.font = textLabel.font.withSize(getCorrectSize(17, 17, 21))
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(20, 20, 26))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: getCorrectSize(30, 30, 42)).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: getCorrectSize(30, 30, 42)).isActive = true
        
        let right = NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: getCorrectSize(-30, -30, -42))
        right.priority = .init(777)
        right.isActive = true
        
        let titleRight = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: getCorrectSize(-30, -30, -42))
        titleRight.priority = .init(777)
        titleRight.isActive = true
        
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: textLabel, attribute: .top, multiplier: 1, constant: -15).isActive = true
        NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
