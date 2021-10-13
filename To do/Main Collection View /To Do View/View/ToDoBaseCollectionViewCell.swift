//
//  ToDoBaseCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoBaseCollectionViewCell : UICollectionViewCell {
    
    var data : ToDoDataViewModel? { didSet{ updateUI() }}
    func updateUI() { }
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.defaultTextColor
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let statusLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let moreButton : UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    lazy var actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1)
        button.setTitleColor(UIColor.secondaryButtonColor, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        return button
    }()
    
    lazy var reminderCounterLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor.defaultTextColor
        return label
    }()
    
    let checkBoxButton : UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let priorityImageView = PriorityImageView(frame: .zero)
    
    var containerWidthLayout : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_ic"), for: .selected)
        checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_unchecked_ic_huge") : #imageLiteral(resourceName: "check_todo_unchecked_ic"), for: .normal)
        moreButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "more_active_ic_huge") : #imageLiteral(resourceName: "more_active_ic"), for: .normal)

        containerWidthLayout = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        containerWidthLayout?.isActive = true
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(15, 15, 19))
        reminderCounterLabel.font = reminderCounterLabel.font.withSize(getCorrectSize(13, 13, 17))
        statusLabel.font = statusLabel.font.withSize(getCorrectSize(13, 13, 17))
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: containerView)
        
        moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        
        contentView.addSubview(priorityImageView)
        contentView.addConstraintsWithFormat(format: "H:[v0]-\(getCorrectSize(5, 5, 8))-|", views: priorityImageView)
        contentView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(5, 5, 8))-[v0]", views: priorityImageView)
        
        setupCell()
        
    }
    
    func setupCell() {}
    
    var moreButtonCompletionAction : ((UICollectionViewCell)->())?
    
    @objc func moreButtonAction() {
        moreButtonCompletionAction?(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

