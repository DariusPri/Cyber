//
//  ToDoInstructionsCheckList.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoInstructionsCheckList: UICollectionViewCell {
    
    var data : CheckListData? { didSet{ updateUI() }}
    
    func updateUI() {
        guard let data = data else { return }
        textLabel.text = data.text
        textLabel.sizeToFit()
    }

    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let redIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "indicator_red")
        imageView.contentMode = .center
        imageView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        return imageView
    }()
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(textLabel)
        contentView.addSubview(redIconImageView)
        
        redIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: redIconImageView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: getCorrectSize(30, 30, 42)).isActive = true
        let leftConstraint = NSLayoutConstraint(item: textLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: getCorrectSize(45, 45, 57))
        leftConstraint.priority = .init(777)
        leftConstraint.isActive = true
        
        NSLayoutConstraint(item: textLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: getCorrectSize(-30, -30, -42)).isActive = true
        NSLayoutConstraint(item: redIconImageView, attribute: .top, relatedBy: .equal, toItem: textLabel, attribute: .top, multiplier: 1, constant: getCorrectSize(10, 10, 8)).isActive = true
        NSLayoutConstraint(item: textLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
