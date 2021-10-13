//
//  MoreButtonViewCell.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class MoreButtonViewCell : UICollectionViewCell {
    
    var data : ToDoButtonData? { didSet{ updateUI() }}
    
    lazy var actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1)
        button.setTitleColor(UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        return button
    }()
    
    func updateUI() {
        guard let data = data else { return }
        actionButton.setTitle(data.name, for: .normal)
    }
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        actionButton.titleLabel?.font = actionButton.titleLabel?.font.withSize(getCorrectSize(10, 10, 14))
        actionButton.layer.cornerRadius = 5 * getCorrectSize(1, 1, 1.4)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(actionButton)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-\(getCorrectSize(30, 30, 42))@777-|", views: actionButton)
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: actionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
