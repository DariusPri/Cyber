//
//  DeviceCell.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class DeviceCell: SettingsCell {
    
    func setDeviceImages(type : DeviceType, status : DeviceStatus) {
        switch type {
        case .phone:
            iconImageView.image = status != .disabled ? #imageLiteral(resourceName: "phone_apple_ic") : #imageLiteral(resourceName: "phone_apple_disabled_ic")
        case .tablet:
            iconImageView.image = status != .disabled ? #imageLiteral(resourceName: "tablet_apple_ic") : #imageLiteral(resourceName: "tablet_apple_disabled_ic")
        default:
            setNotExistingDeviceImage(isDisabled: status == .disabled)
        }
    }
    
    func updateUI(with currentDevice : DeviceData?) {
        
        deviceNameLabel.text = "\(UIDevice.current.name) - \(UIDevice.current.modelName)"
        versionLabel.text = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        
        guard let device = currentDevice else {
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .pad:
                setDeviceImages(type: DeviceType.tablet, status: .active)
            case .phone:
                setDeviceImages(type: DeviceType.phone, status: .active)
            default:
                setNotExistingDeviceImage(isDisabled: false)
            }
            return
        }
        
        statusButton.isEnabled = device.status == .active
        setDeviceImages(type: DeviceType(string: device.type), status: device.status)
    }
    
    private func setNotExistingDeviceImage(isDisabled : Bool) {
        iconImageView.image = isDisabled == false ? #imageLiteral(resourceName: "device_not_found") : #imageLiteral(resourceName: "device_not_found_disabled")
    }
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        return view
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "phone_apple_ic")
        return imageView
    }()
    
    let deviceNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.textAlignment = .left
        label.text = "Ann’s phone - iPhone Xs"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let statusButton : UIButton = {
        let button = UIButton()
        button.setTitle(Localization.shared.active, for: .normal)
        button.setTitle(Localization.shared.pending, for: .disabled)
        button.setTitleColor(UIColor(red: 114/255, green: 204/244, blue: 87/255, alpha: 1), for: .normal)
        button.setTitleColor(.red, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.titleLabel?.font = UIFont(name: "Muli-Regular", size: 15)
        return button
    }()
    
    let versionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.textAlignment = .left
        label.text = "IOS 11.0.1 update required"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let lineSeparator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        view.backgroundColor = .gray
        return view
    }()
    
    let tasksCounterLabel : AnimatedLabel = {
        let label = AnimatedLabel()
        label.font = UIFont(name: "Muli-Regular", size: 35)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.textAlignment = .center
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.sizeToFit()
        return label
    }()
    
    let tasksCounterExplainerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.textAlignment = .left
        label.text = Localization.shared.dashboard_tasks_to_finish_in_order_to_protect_yourself
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let explainerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Italic", size: 15)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.textAlignment = .left
        label.text = Localization.shared.dashboard_you_need_to_complete_all_task_in_order_to_be_prote
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let bottomInfoStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        deviceNameLabel.font = deviceNameLabel.font.withSize(getCorrectSize(15, 15, 20))
        statusButton.titleLabel?.font = statusButton.titleLabel?.font.withSize(getCorrectSize(15, 15, 20))
        versionLabel.font = versionLabel.font.withSize(getCorrectSize(15, 15, 20))
        tasksCounterLabel.font = tasksCounterLabel.font.withSize(getCorrectSize(35, 35, 46))
        tasksCounterExplainerLabel.font = tasksCounterExplainerLabel.font.withSize(getCorrectSize(15, 15, 20))
        explainerLabel.font = explainerLabel.font.withSize(getCorrectSize(15, 15, 20))
        
        contentView.addSubview(containerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)

        containerView.addSubview(iconImageView)
        containerView.addSubview(deviceNameLabel)
        containerView.addSubview(statusButton)
        containerView.addSubview(lineSeparator)
        containerView.addSubview(versionLabel)
        
        containerView.addSubview(explainerLabel)
        
        bottomInfoStackView.spacing = getCorrectSize(20, 20, 28)
        bottomInfoStackView.addArrangedSubview(tasksCounterLabel)
        bottomInfoStackView.addArrangedSubview(tasksCounterExplainerLabel)
        containerView.addSubview(bottomInfoStackView)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(10, 10, 20))-[v0(\(getCorrectSize(90, 90, 120)))]-\(getCorrectSize(18, 18, 24))-[v1]-\(getCorrectSize(10, 10, 20))-|", views: iconImageView, deviceNameLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(10, 10, 20))-[v0]-\(getCorrectSize(18, 18, 24))-[v1]-(>=10)-|", views: iconImageView, statusButton)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(10, 10, 20))-[v0]-\(getCorrectSize(18, 18, 24))-[v1]-\(getCorrectSize(10, 10, 20))-|", views: iconImageView, versionLabel)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(10, 10, 20))-[v0(\(getCorrectSize(90, 90, 120)))]-\(getCorrectSize(20, 20, 26))-[v1]", views: iconImageView, lineSeparator)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(25, 25, 36))-[v0]-\(getCorrectSize(8, 8, 12))-[v1][v2]-(>=\(getCorrectSize(4, 4, 7)))-[v3]", views: deviceNameLabel, statusButton, versionLabel, lineSeparator)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 28))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: lineSeparator)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 32))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: explainerLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 32))-[v0]-\(getCorrectSize(20, 20, 28))-|", views: bottomInfoStackView)

        containerView.addConstraintsWithFormat(format: "V:[v0]-\(getCorrectSize(17, 17, 24))-[v1]-\(getCorrectSize(4, 4, 8))-[v2]-\(getCorrectSize(20, 20, 28))-|", views: lineSeparator, bottomInfoStackView, explainerLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0]-\(getCorrectSize(17, 17, 24))-[v1]-\(getCorrectSize(4, 4, 8))-[v2]-\(getCorrectSize(20, 20, 28))-|", views: lineSeparator, bottomInfoStackView, explainerLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
