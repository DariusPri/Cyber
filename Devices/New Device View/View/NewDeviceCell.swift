//
//  NewDeviceCell.swift
//  Xpert
//
//  Created by Darius on 30/11/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class NewDeviceCell: UICollectionViewCell {
    
    override var isSelected: Bool { didSet{ selectedCellStateChanged() } }
    
    var data : (title: String?, deviceType: DeviceType?)? { didSet { updateUI() }}
    
    func updateUI() {
        guard let data = data else { return }
        
        titleLabel.text = data.title
        
        guard let type = data.deviceType else { return }
        
        if mainStack.arrangedSubviews.count == 1 {
            mainStack.insertArrangedSubview(iconImageView, at: 0)
        }
        
        switch type {
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
        case .apple, .android, .windows:
            mainStack.removeArrangedSubview(iconImageView)
        }
    }
    
    func selectedCellStateChanged() {
        iconImageView.tintColor = isSelected == true ? .white : .primaryButtonColor
        backgroundColor = isSelected == true ? .primaryButtonColor : .secondaryButtonColor
        titleLabel.textColor = isSelected == true ? .white : .primaryButtonColor
    }
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintColor = .primaryButtonColor
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 10)
        label.textColor = .primaryButtonColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let mainStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondaryButtonColor
        addSubview(iconImageView)
        addSubview(titleLabel)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(10, 10, 12))
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.alignment = .center
        mainStack.axis = .vertical
        mainStack.spacing = getCorrectSize(4, 4, 8)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.widthAnchor.constraint(equalToConstant: getCorrectSize(40, 40, 52)).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(40, 40, 52)).isActive = true
        
        contentView.addSubview(mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
