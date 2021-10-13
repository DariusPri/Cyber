//
//  InactiveDeviceCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 24/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class InactiveDeviceCollectionViewCell : DeviceCollectionViewBaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(deviceNameLabel)
        containerView.addSubview(statusButton)
        containerView.addSubview(lineSeparator)
        containerView.addSubview(activateDeviceButton)
        containerView.addSubview(infoLabel)
        
        statusButton.isEnabled = false
        
        activateDeviceButton.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: getCorrectSize(10, 10, 13  ))

        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 32))-[v0(\(getCorrectSize(91, 91, 114)))]-31-[v1]-10-|", views: iconImageView, deviceNameLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 32))-[v0]-31-[v1]", views: iconImageView, statusButton)
        NSLayoutConstraint(item: deviceNameLabel, attribute: .bottom, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: -5).isActive = true
        NSLayoutConstraint(item: statusButton, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 5).isActive = true
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 28))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: infoLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 28))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: lineSeparator)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 28))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: activateDeviceButton)
        
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(14, 14, 26))-[v0(\(getCorrectSize(91, 91, 114)))]-\(getCorrectSize(14, 14, 26))-[v1]-\(getCorrectSize(14, 14, 26))-[v2]-\(getCorrectSize(14, 14, 26))-[v3]-\(getCorrectSize(14, 14, 26))-|", views: iconImageView, lineSeparator, infoLabel, activateDeviceButton)

        
        statusButton.sizeToFit()
        
        containerView.addConstraintsWithFormat(format: "H:[v0(24)]-20-|", views: infoButton)
        NSLayoutConstraint(item: infoButton, attribute: .centerY, relatedBy: .equal, toItem: iconImageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        containerView.bringSubviewToFront(infoButton)

    }
    
    override func updateUI() {
        super.updateUI()
        let isThisDevice = data?.fingerprint == UIDevice.current.identifierForVendor!.uuidString.sha512
        statusButton.text = Localization.shared.pending
        if isThisDevice == true { statusButton.text = "\(statusButton.text!) - \(Localization.shared.devices_this_device.lowercased())" }
        
        let buttonTitle = isThisDevice == true ? Localization.shared.device_activate.uppercased() : Localization.shared.resend_activation_email.uppercased()
        activateDeviceButton.setTitle(buttonTitle, for: .normal)
        
        let infoLabelText = isThisDevice == true ? Localization.shared.devices_this_device_has_not_been_activated_yet : Localization.shared.devices_check_you_inbox_for_an_email_with_instructions_to_
        infoLabel.text = infoLabelText
        infoLabel.sizeToFit()
        
    }

}
