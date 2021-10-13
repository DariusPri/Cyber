//
//  NewDeviceCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 24/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class NewDeviceCollectionViewCell: UICollectionViewCell {
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "deviceNewDeviceBgColor")
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "deviceNewDeviceBorderColor")!.cgColor
        return view
    }()
    
    let addDeviceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.text = Localization.shared.add_device
        label.textColor = UIColor(named: "deviceNewDeviceTextColor")
        return label
    }()
    
    let addDeviceButton : UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(named: "deviceNewDeviceButtonColor")
        button.imageView?.tintColor = UIColor(named: "deviceNewDeviceButtonTintColor")
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    var containerWidthLayout : NSLayoutConstraint?
    var containerHeightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        resetIfNeeded()
        
        addDeviceButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "adddevice_ic_huge") : #imageLiteral(resourceName: "adddevice_ic"), for: .normal)
        addDeviceButton.layer.cornerRadius = isHugeScreenSize == true ? 1.6 * 3 : 3
        addDeviceLabel.font = addDeviceLabel.font.withSize(getCorrectSize(15, 15, 19))
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: containerView)
        
        containerView.addSubview(addDeviceLabel)
        containerView.addSubview(addDeviceButton)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(30, 30, 38)))]", views: addDeviceButton)
        containerView.addConstraintsWithFormat(format: "H:|-30-[v0]-10-[v1(\(getCorrectSize(30, 30, 38)))]-\(getCorrectSize(15, 20, 20))-|", views: addDeviceLabel, addDeviceButton)
        NSLayoutConstraint(item: addDeviceLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: addDeviceButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        containerWidthLayout = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        containerWidthLayout?.isActive = true
        
        containerHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: getCorrectSize(50, 80, 80))
        containerHeightConstraint?.isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetIfNeeded() {
        if #available(iOS 13.0, *) {
            self.traitCollection.performAsCurrent {
                containerView.layer.borderColor = UIColor(named: "deviceNewDeviceBorderColor")!.cgColor
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


