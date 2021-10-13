//
//  SettingsActionCells.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SettingsActionCell: UICollectionViewCell {
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "listItemBackgroundColor")
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "settingsActionTextColor")
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "settingsActionButtonColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrow_right_blue"), for: .normal)
        button.imageView?.tintColor = UIColor(named: "settingsActionButtonTintColor")
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = false
        return button
    }()
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        actionButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "arrow_right_blue_huge") : #imageLiteral(resourceName: "arrow_right_blue"), for: .normal)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(15, 15, 21))
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: getCorrectSize(60, 60, 82))
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(actionButton)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0]-10@777-[v1(\(getCorrectSize(29, 29, 36)))]-\(getCorrectSize(20, 20, 26))-|", views: titleLabel, actionButton)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(29, 29, 36)))]", views: actionButton)
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
    }
    
    func resetIfNeeded() {
         if #available(iOS 13.0, *) {
             self.traitCollection.performAsCurrent {
                 containerView.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SettingsRadioCell: UICollectionViewCell {
    
    let radioButton = UISwitch()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let lineSeparator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "settingsrSeparatorColor")
        return view
    }()
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    
    
    func setupCellRoundness(firstCell : Bool, lastCell : Bool) {
        
        containerView.layer.cornerRadius = 0
        containerView.layer.maskedCorners = []
        lineSeparator.alpha = 1
        
        if firstCell == true {
            containerView.layer.cornerRadius = 10
            containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            containerView.addBottomBorderWithColor(color: .clear, width: 1)
        }
        
        if lastCell == true {
            containerView.layer.cornerRadius = 10
            lineSeparator.alpha = 0
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
            containerView.addTopBorderWithColor(color: .white, width: 1)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(15, 15, 21))
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: getCorrectSize(60, 60, 82))
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(radioButton)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0]-80@777-|", views: titleLabel)
        containerView.addConstraintsWithFormat(format: "H:[v0]-\(getCorrectSize(20, 20, 26))@777-|", views: radioButton)

        
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: radioButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        radioButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        radioButton.onTintColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        radioButton.tintColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        radioButton.backgroundColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        radioButton.layer.cornerRadius = 15
        
        containerView.addSubview(lineSeparator)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0]-\(getCorrectSize(20, 20, 26))@777-|", views: lineSeparator)
        containerView.addConstraintsWithFormat(format: "V:[v0(1)]|", views: lineSeparator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
