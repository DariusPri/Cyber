//
//  ToDoCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoCollectionViewCell : ToDoBaseCollectionViewCell {
    
    override func setupCell() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)
        containerView.addSubview(iconImageView)
        containerView.addSubview(moreButton)
        containerView.addSubview(checkBoxButton)
        containerView.addSubview(statusLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 20))-[v0(\(getCorrectSize(24, 24, 30)))]-\(getCorrectSize(15, 15, 21))-[v1]-(2)-[v2(\(getCorrectSize(18, 18, 24)))]-\(getCorrectSize(2, 2, 14))-[v3(\(getCorrectSize(24, 24, 18)))]-\(getCorrectSize(8, 8, 12))-|", views: checkBoxButton, titleLabel, iconImageView, moreButton)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(17, 17, 22))-[v0]-\(getCorrectSize(5, 5, 8))-[v1]-\(getCorrectSize(26, 26, 32))-[v2(\(getCorrectSize(26, 26, 32)))]-\(getCorrectSize(15, 15, 21))-|", views: titleLabel, statusLabel, actionButton)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(24, 24, 18)))]", views: moreButton)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(17, 17, 22))-[v0(\(getCorrectSize(18, 18, 24)))]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(15, 15, 20))-[v0(\(getCorrectSize(24, 24, 30)))]", views: checkBoxButton)
        containerView.addConstraintsWithFormat(format: "H:[v0]-\(getCorrectSize(18, 18, 24))-|", views: actionButton)
        NSLayoutConstraint(item: actionButton, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: statusLabel, attribute: .left, relatedBy: .equal, toItem: titleLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: moreButton, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true 
        
        actionButton.setTitle(Localization.shared.how_to_do_it.uppercased(), for: .normal)
        actionButton.titleLabel?.font = actionButton.titleLabel?.font.withSize(getCorrectSize(10, 10, 12))
        actionButton.addTarget(self, action: #selector(howToDoItAction), for: .touchUpInside)
        checkBoxButton.isSelected = false
    }
    
    var howToDoItCompletionAction : ((ToDoCollectionViewCell)->())?
    
    @objc func howToDoItAction() {
        howToDoItCompletionAction?(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
    }
    
    override func updateUI() {
        guard let data = data else { return }
        titleLabel.text = data.name
        
        if data.isEnabled == true {
            checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_ic"), for: .selected)
            checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_unchecked_ic_huge") : #imageLiteral(resourceName: "check_todo_unchecked_ic"), for: .normal)
            moreButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "more_active_ic_huge") : #imageLiteral(resourceName: "more_active_ic"), for: .normal)

        } else {
            checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_checked_disabled_ic_huge") : #imageLiteral(resourceName: "check_todo_checked_disabled_ic"), for: .selected)
            checkBoxButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "check_todo_unchecked_disabled_ic_huge") : #imageLiteral(resourceName: "check_todo_unchecked_disabled_ic"), for: .normal)
            moreButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "more_disbaled_ic_huge") : #imageLiteral(resourceName: "more_disbaled_ic"), for: .normal)
        }
        

        switch data.device.type {
        case .personal:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_choice_ic_huge") : #imageLiteral(resourceName: "personalsec_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_disbaled_ic_huge") : #imageLiteral(resourceName: "personalsec_disbaled_ic") }
        case .desktop:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "pc_choice_ic_huge") : #imageLiteral(resourceName: "pc_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "pc_disabled_ic_huge") : #imageLiteral(resourceName: "pc_disabled_ic") }
        case .laptop:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "laptop_choice_ic_huge") : #imageLiteral(resourceName: "laptop_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "laptop_disbaled_ic_huge") : #imageLiteral(resourceName: "laptop_disbaled_ic") }
        case .phone:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "phone_choice_ic_huge") : #imageLiteral(resourceName: "phone_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "phone_disabeld_ic_huge") : #imageLiteral(resourceName: "phone_disabeld_ic") }
        case .tablet:
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "tablet_choice_ic_huge") : #imageLiteral(resourceName: "tablet_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "tablet_disbaled_ic_huge") : #imageLiteral(resourceName: "tablet_disbaled_ic") }
        default :
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_choice_ic_huge") : #imageLiteral(resourceName: "personalsec_choice_ic")
            if data.isEnabled == false { iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_disbaled_ic_huge") : #imageLiteral(resourceName: "personalsec_disbaled_ic") }
        }
        
        checkBoxButton.isEnabled = true
        moreButton.isEnabled = true

        switch data.status {
        case .completed:
            statusLabel.text = ""
            checkBoxButton.isSelected = true
            titleLabel.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
            let attrString = NSAttributedString(string: data.name, attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            titleLabel.attributedText = attrString
            moreButton.isEnabled = false
        case .overdue:
            checkBoxButton.isSelected = false
            titleLabel.textColor = .black
            statusLabel.text = TaskStatus.overdue.localized()
            statusLabel.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
        case .postponed:
            checkBoxButton.isEnabled = false
            titleLabel.textColor = .black
            statusLabel.textColor = UIColor(red: 95/255, green: 104/255, blue: 119/255, alpha: 1)
            statusLabel.text = TaskStatus.postponed.localized() //+"\n"+Localization.shared.to_due_in_days_days.doubleBracketReplace(with: "\(data.dueTime ?? 0)")
            moreButton.isEnabled = false
        default:
            checkBoxButton.isSelected = false
            titleLabel.textColor = .black
            statusLabel.text = ""
            statusLabel.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        }
        
        if data.isEnabled == true {
            containerView.backgroundColor = .white
            actionButton.backgroundColor = UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1)
            actionButton.setTitleColor(UIColor(named: "todoHowToButtonTextColor"), for: .normal)
            containerView.layer.borderColor = UIColor(named: "toDoBgBorderColor")!.cgColor

            moreButton.alpha = 1
            iconImageView.alpha = 1
            priorityImageView.alpha = 1
            checkBoxButton.alpha = 1
        } else {
            containerView.backgroundColor = UIColor(named: "toDoBgViewDisabledColor")
            actionButton.backgroundColor = UIColor(named: "toDoActionButtonBgDisabledColor")
            actionButton.setTitleColor(UIColor(named: "toDoActionButtonTitleDisabledColor"), for: .normal)
            statusLabel.textColor = UIColor(named: "toDoStatusLabelDisabledTextColor")
            titleLabel.textColor = UIColor(named: "toDoTitleLabelDisabledTextColor")
            containerView.layer.borderColor = UIColor(named: "toDoBgBorderDisabledColor")!.cgColor
            
            moreButton.alpha = 0.5
            iconImageView.alpha = 0.5
            priorityImageView.alpha = 0.5
            checkBoxButton.alpha = 0.5
        }
        
        containerView.bringSubviewToFront(checkBoxButton)
    }
    
    func resetIfNeeded() {
            if #available(iOS 13.0, *) {
                self.traitCollection.performAsCurrent {
                    guard let enabled = data?.isEnabled else { return }
                    if enabled == true {
                        containerView.layer.borderColor = UIColor(named: "toDoBgBorderColor")!.cgColor
                    } else {
                        containerView.layer.borderColor = UIColor(named: "toDoBgBorderDisabledColor")!.cgColor
                    }
                }
            }
        }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            resetIfNeeded()
        }
    }
}

