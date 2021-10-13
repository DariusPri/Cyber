//
//  DeviceStatusCell.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class DeviceStatusCell: SettingsCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        actionButton.isEnabled = true 
    }
    
    let statusTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(named: "DashboardDeviceStatusTitleTextColor")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let lineSeparator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    let iconImageView = StatusLoadingImageView(frame: .zero)

    let actionButton : UIButton = {
        let button = UIButton()
        button.isEnabled = true 
        button.backgroundColor = UIColor(named: "dashboardDeviceStatusButtonBgColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "arrow_right_blue"), for: .normal)
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        button.tintColor = UIColor(named: "dashboardDeviceStatusButtonArrowTintColor")
        return button
    }()
    
    func setImageViewTick(enabled : Bool) {
        if enabled == true {
            iconImageView.image = UIImage(named: "check_ic")
        } else {
            iconImageView.image = UIImage(named: "uncheck_ic")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        lineSeparator.widthAnchor.constraint(equalToConstant: getCorrectSize(0.4, 0.4, 0.6)).isActive = true
        statusTitleLabel.font = statusTitleLabel.font.withSize(getCorrectSize(15, 15, 18))
        
        contentView.addSubview(statusTitleLabel)
        contentView.addSubview(lineSeparator)
        contentView.addSubview(iconImageView)
        contentView.addSubview(actionButton)
        
        actionButton.heightAnchor.constraint(equalToConstant: getCorrectSize(30, 30, 38)).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: getCorrectSize(12, 12, 14)).isActive = true
        addConstraintsWithFormat(format: "H:|-20-[v0]-25-[v1]-10-[v2(\(getCorrectSize(30, 30, 38)))]-\(getCorrectSize(10, 10, 14))-|", views: lineSeparator, statusTitleLabel, actionButton)
        NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: lineSeparator, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        addConstraintsWithFormat(format: "V:|[v0]-\(getCorrectSize(10, 10, 18))-[v1(\(getCorrectSize(12, 12, 14)))]-\(getCorrectSize(10, 10, 18))-|", views: lineSeparator, iconImageView)
        NSLayoutConstraint(item: statusTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .centerY, relatedBy: .equal, toItem: statusTitleLabel, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class StatusLoadingImageView: UIImageView {
    
    var spinningWheel : UIActivityIndicatorView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        image = UIImage(named: "uncheck_ic")
        setupSpinningWheel()
        setupLoader()
    }
    
    func setupSpinningWheel() {
        let style : UIActivityIndicatorView.Style = .medium
        spinningWheel = UIActivityIndicatorView(style: style)
        spinningWheel!.translatesAutoresizingMaskIntoConstraints = false
        spinningWheel!.hidesWhenStopped = true
    }
    
    func setupLoader() {
        addSubview(spinningWheel!)
        NSLayoutConstraint(item: spinningWheel!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinningWheel!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func startLoaderAnimating() {
        image = nil
        spinningWheel?.startAnimating()
    }
    
    func stopLoaderAnimation() {
        spinningWheel?.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
