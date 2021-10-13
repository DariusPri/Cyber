//
//  DeviceCollectionViewBaseCell.swift
//  Xpert
//
//  Created by Darius on 24/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class DeviceCollectionViewBaseCell : UICollectionViewCell {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activateDeviceButton.isEnabled = true
        
    }
    
    private func setNotExistingDeviceImage(isDisabled : Bool) {
        if isDisabled == false {
            iconImageView.image = #imageLiteral(resourceName: "device_not_found")
        } else {
            iconImageView.image = #imageLiteral(resourceName: "device_not_found_disabled")
        }
    }
    
    var data : DeviceDataViewModel? { didSet { updateUI() }}
    func updateUI() {
        guard let d = data else { return }
        deviceNameLabel.text = d.device.name
        statusButton.text = d.status.getString()
        taskCountLabel.text = d.taskCountString
        
        activateDeviceButton.isEnabled = d.isActivationButtonActive
        
        if d.os == .ios {
            if d.device.type == .phone {
                if d.status != .disabled {
                    iconImageView.image = #imageLiteral(resourceName: "phone_apple_ic")
                } else {
                    iconImageView.image = #imageLiteral(resourceName: "phone_apple_disabled_ic")
                }
            } else if d.device.type == .tablet {
                if d.status != .disabled {
                    iconImageView.image = #imageLiteral(resourceName: "tablet_apple_ic")
                } else {
                    iconImageView.image = #imageLiteral(resourceName: "tablet_apple_disabled_ic")
                }
            } else {
                setNotExistingDeviceImage(isDisabled: d.status == .disabled)
            }
        } else if d.os == .android {
            if d.device.type == .phone {
                if d.status != .disabled {
                    iconImageView.image = #imageLiteral(resourceName: "phone_android_ic")
                } else {
                    iconImageView.image = #imageLiteral(resourceName: "phone_android_disabled_ic_light")
                }
            } else if d.device.type == .tablet {
                if d.status != .disabled {
                    iconImageView.image = #imageLiteral(resourceName: "tablet_android_ic")
                } else {
                    iconImageView.image = #imageLiteral(resourceName: "android_tablet_disabled_ic")
                }
            } else {
                setNotExistingDeviceImage(isDisabled: d.status == .disabled)
            }
        } else if d.os == .mac {
                if d.status != .disabled {
                    iconImageView.image = #imageLiteral(resourceName: "pc_apple_ic")
                } else {
                    iconImageView.image = #imageLiteral(resourceName: "pc_apple_disabled_ic")
                }
        } else if d.os == .windows {
            if d.device.type == .phone {
                if d.status != .disabled {
                    iconImageView.image =  #imageLiteral(resourceName: "phone_windows_ic")
                } else {
                    iconImageView.image =  #imageLiteral(resourceName: "phone_windows_disabled_ic")
                }
            } else if d.device.type == .tablet {
                if d.status != .disabled {
                    iconImageView.image =  #imageLiteral(resourceName: "tablet_windows_ic")
                } else {
                    iconImageView.image =  #imageLiteral(resourceName: "tablet_windows_disabled_ic")
                }
            } else if d.device.type == .laptop {
                if d.status != .disabled {
                    iconImageView.image =  #imageLiteral(resourceName: "laptop_windows_ic")
                } else {
                    iconImageView.image =  #imageLiteral(resourceName: "laptop_windows_disabled_ic")
                }
            } else {
                if d.status != .disabled {
                    iconImageView.image =  #imageLiteral(resourceName: "pc_windows_ic")
                } else {
                    iconImageView.image =  #imageLiteral(resourceName: "pc_windows_disabled_ic")
                }
            }
        }
    }
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "phone_apple_ic")
        return imageView
    }()
    
    lazy var deviceNameLabel : UILabel = {
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
    
    lazy var statusButton : UILabel = {
        let button = UILabel()
        button.text = Localization.shared.active.capitalized
        button.textColor = UIColor(red: 114/255, green: 204/244, blue: 87/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font = UIFont(name: "Muli-Regular", size: 15)
        return button
    }()
    
    lazy var taskCountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.textAlignment = .left
        label.text = "10 Tasks"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    lazy var lineSeparator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.textAlignment = .left
        label.text = "This device has not been activated yet"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let infoButton : UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var containerWidthLayout : NSLayoutConstraint?
    
    lazy var activateDeviceButton = SquareButton(title: Localization.shared.device_activate.uppercased(), image: nil, backgroundColor: UIColor(named: "deviceActivateDeviceButtonBgColor")!, textColor: UIColor(named: "deviceActivateDeviceButtonTextColor")!)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        infoButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "more_active_ic_huge") : #imageLiteral(resourceName: "more_active_ic") , for: .normal)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: containerView)
        
        infoLabel.font = infoLabel.font.withSize(getCorrectSize(15, 15, 19))
        lineSeparator.heightAnchor.constraint(equalToConstant: getCorrectSize(0.4, 0.4, 0.6)).isActive = true
        taskCountLabel.font = taskCountLabel.font.withSize(getCorrectSize(15, 15, 19))
        statusButton.font = statusButton.font.withSize(getCorrectSize(15, 15, 19))
        deviceNameLabel.font = deviceNameLabel.font.withSize(getCorrectSize(15, 15, 19))
        
        containerView.addSubview(infoButton)
        
        containerWidthLayout = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
           containerWidthLayout?.isActive = true

    }
    
    var infoButtonActionCompletion : ((DeviceCollectionViewBaseCell)->())?

}
