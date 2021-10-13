//
//  ToDoCollectionViewHeader.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class ToDoCollectionViewHeader : UICollectionReusableView {
    
    private let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "todoFilterBgColor")
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        return view
    }()
    
    let filterTasksLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.text = Localization.shared.to_filter_tasks
        label.textColor = UIColor(named: "todoFilterTextColor")
        return label
    }()
    
    public let filterTasksButton : UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 3
        button.tintColor = UIColor(named: "todoFilterButtonTintColor")
        button.imageView?.contentMode = .center
        return button
    }()
    
    lazy var removeFilteringButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mainStack : UIStackView = UIStackView()
    
    var leftStackConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        mainStack.spacing = getCorrectSize(10, 10, 14)
        removeFilteringButton.tintColor = UIColor.primaryButtonColor
        removeFilteringButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "clear_x_ic_huge") : #imageLiteral(resourceName: "clear_x_ic"), for: .normal)
        removeFilteringButton.widthAnchor.constraint(equalToConstant: getCorrectSize(22, 22, 26)).isActive = true
        removeFilteringButton.heightAnchor.constraint(equalToConstant: getCorrectSize(22, 22, 26)).isActive = true
        
        filterTasksLabel.font = filterTasksLabel.font.withSize(getCorrectSize(15, 15, 20))
        
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        mainStack.addArrangedSubview(filterTasksLabel)
        containerView.addSubview(mainStack)
        containerView.addSubview(filterTasksButton)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(30, 30, 34)))]", views: filterTasksButton)
        containerView.addConstraintsWithFormat(format: "H:[v0]-10-[v1(\(getCorrectSize(30, 30, 34)))]-\(getCorrectSize(15, 15, 21))-|", views: mainStack, filterTasksButton)
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: filterTasksButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        leftStackConstraint = NSLayoutConstraint(item: mainStack, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1, constant: 18)
        leftStackConstraint?.isActive = true
    }
    
    func filteringIs(enabled : Bool) {
        if enabled == true {
            mainStack.insertArrangedSubview(removeFilteringButton, at: 0)
            containerView.backgroundColor = .white
            containerView.layer.borderWidth = 1
            filterTasksButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "filter_applied_ic_huge").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "filter_applied_ic").withRenderingMode(.alwaysTemplate), for: .normal)
            filterTasksButton.tintColor = UIColor(named: "todoFilterOnButtonTintColor")
            leftStackConstraint?.constant = getCorrectSize(18, 18, 24)
            filterTasksLabel.textColor = .defaultTextColor
            filterTasksLabel.text = Localization.shared.to_clear_filter
            removeFilteringButton.alpha = 1
        } else {
            mainStack.removeArrangedSubview(removeFilteringButton)
            containerView.backgroundColor = UIColor(named: "todoFilterBgColor")
            containerView.layer.borderWidth = 0
            filterTasksButton.setImage(#imageLiteral(resourceName: "filter_ic"), for: .normal)
            filterTasksButton.tintColor = UIColor(named: "todoFilterButtonTintColor")
            filterTasksButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "filter_ic_huge").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "filter_ic").withRenderingMode(.alwaysTemplate), for: .normal)
            leftStackConstraint?.constant = getCorrectSize(30, 30, 38)
            filterTasksLabel.textColor = UIColor(named: "todoFilterTextColor")
            filterTasksLabel.text = Localization.shared.to_filter_tasks
            removeFilteringButton.alpha = 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
