//
//  FilterSelectionCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class FilterSelectionCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool { didSet{ selectedCellStateChanged() } }

    func selectedCellStateChanged() {
        iconImageView.tintColor = isSelected == true ? UIColor.white : UIColor.primaryButtonColor
        containerView.backgroundColor = isSelected == true ? UIColor.primaryButtonColor : UIColor.secondaryButtonColor
        titleLabel.textColor = isSelected == true ? UIColor.white : UIColor.defaultTextColor
        subtitleLabel.textColor = isSelected == true ? UIColor.white : UIColor.defaultTextColor
    }
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        label.font = UIFont(name: "Muli-ExtraBold", size: 10)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var subtitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.defaultTextColor
        label.font = UIFont(name: "Muli-Regular", size: 10)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.tintColor = UIColor.primaryButtonColor
        return imageView
    }()
    
    let mainStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 5
        return stack
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 223/255, green: 242/255, blue: 250/255, alpha: 1)
        view.layer.cornerRadius = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(10, 10, 12))
        subtitleLabel.font = subtitleLabel.font.withSize(getCorrectSize(10, 10, 12))
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .width, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .width, multiplier: 1, constant: -20).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .height, relatedBy: .lessThanOrEqual, toItem: containerView, attribute: .height, multiplier: 1, constant: -20).isActive = true
        
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(with priority : PriorityFilterData?, status : StatusFilterData?, device: DeviceFilterData?) {
        if let p = priority {
            mainStack.addArrangedSubview(titleLabel)
            titleLabel.text = "\(p.priority.localized())"
        } else if let s = status {
            mainStack.addArrangedSubview(titleLabel)
            titleLabel.text = "\(s.status.localized().uppercased())"
        } else if let d = device {
            switch DeviceType(string: d.device.type) {
            case .personal:
                iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "personalsec_choice_filter_ic_huge") : #imageLiteral(resourceName: "personalsec_choice_ic")
            case .desktop:
                iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "pc_choice_filter_ic_huge") : #imageLiteral(resourceName: "pc_choice_ic")
            case .laptop:
                iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "laptop_choice_filter_ic_huge") : #imageLiteral(resourceName: "laptop_choice_ic")
            case .phone:
                iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "phone_choice_filter_ic_huge") : #imageLiteral(resourceName: "phone_choice_ic")
            case .tablet:
                iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "tablet_choice_filter_ic_huge") : #imageLiteral(resourceName: "tablet_choice_ic")
            default:
                break
            }
            
            mainStack.addArrangedSubview(iconImageView)
            iconImageView.widthAnchor.constraint(equalToConstant: getCorrectSize(40, 40, 56)).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(40, 40, 56)).isActive = true
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            mainStack.addArrangedSubview(subtitleLabel)
            subtitleLabel.text = d.device.name
        }
    }
    
}
