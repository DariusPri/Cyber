//
//  ActiveDeviceCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 24/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ActiveDeviceCollectionViewCell : DeviceCollectionViewBaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(deviceNameLabel)
        containerView.addSubview(statusButton)
        containerView.addSubview(taskCountLabel)
        containerView.addConstraintsWithFormat(format: "H:[v0(24)]-20-|", views: infoButton)
        NSLayoutConstraint(item: infoButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        containerView.bringSubviewToFront(infoButton)

        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 32))-[v0(\(getCorrectSize(91, 91, 114)))]-31-[v1]-4-[v2]", views: iconImageView, deviceNameLabel, infoButton)
        containerView.addConstraintsWithFormat(format: "H:[v0]-31-[v1]-4-[v2]", views: iconImageView, statusButton, infoButton)
        containerView.addConstraintsWithFormat(format: "H:[v0]-31-[v1]-4-[v2]", views: iconImageView, taskCountLabel, infoButton)
        NSLayoutConstraint(item: deviceNameLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: (getCorrectSize(22, 22, 34))).isActive = true
        let a = NSLayoutConstraint(item: taskCountLabel, attribute: .bottom, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: getCorrectSize(-10, -20, -20))
        a.priority = .init(rawValue: 500)
        a.isActive = true
        
        containerView.addConstraintsWithFormat(format: "V:[v0]-(>=4)-[v1]-4-[v2]-\(getCorrectSize(22, 42, 42))-|", views: deviceNameLabel, statusButton, taskCountLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(90, 90, 114)))]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "V:|-(>=\(getCorrectSize(14, 14, 26)))-[v0]-(>=\(getCorrectSize(14, 14, 26)))-|", views: iconImageView)

        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    }
    
    var topImageViewConstraint : NSLayoutConstraint?
    
    override func updateUI() {
        super.updateUI()
        guard let data = data else { return }
        
        statusButton.numberOfLines = 0
        statusButton.lineBreakMode = .byWordWrapping
        
        if data.status == .disabled {
            iconImageView.alpha = 0.4
            let disabledColor = UIColor(red: 81/255, green: 105/255, blue: 127/255, alpha: 0.4)
            deviceNameLabel.textColor = disabledColor
            statusButton.textColor = disabledColor
            taskCountLabel.textColor = disabledColor
            statusButton.text = Localization.shared.disabled+" - "+Localization.shared.we_sent_an_activation_email_subheader
            statusButton.sizeToFit()
            containerView.backgroundColor = UIColor(red: 250/255, green: 253/255, blue: 255/255, alpha: 1)
            return 
        } else {
            iconImageView.alpha = 1
            deviceNameLabel.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
            statusButton.text = Localization.shared.active
            statusButton.textColor = UIColor(red: 114/255, green: 204/244, blue: 87/255, alpha: 1)
            statusButton.sizeToFit()
            containerView.backgroundColor = .white
            taskCountLabel.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        }
        
        taskCountLabel.text = Localization.shared.x_tasks.doubleBracketReplace(with: data.taskCountString)
        
        let isThisDevice = data.fingerprint == UIDevice.current.identifierForVendor!.uuidString.sha512
        if isThisDevice == true {
            if (statusButton.text?.count ?? 0) > 0 {
                statusButton.text = "\(statusButton.text!) - \(Localization.shared.devices_this_device.lowercased())"
            } else {
                statusButton.text = Localization.shared.devices_this_device.capitalized
            }
        }
    }
    
}
