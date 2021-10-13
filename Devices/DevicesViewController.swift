//
//  DevicesViewController.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class DevicesViewController: NavViewController {
    
    let devicesCollectionViewController = DevicesCollectionViewController()
    var devicesCVContainerHeightConstraint : NSLayoutConstraint?
    
    init() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        super.init(leftButton: nil, rightButton: button, title: Localization.shared.devices, subtitle: "0 "+Localization.shared.devices.lowercased())
        subtitleLabel.font = subtitleLabel.font.withSize(view.getCorrectSize(12, 12, 16))
        button.heightAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "settings ic_max") : #imageLiteral(resourceName: "settings_ic"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        view.addSubview(devicesCollectionViewController.view)
        addChild(devicesCollectionViewController)
        devicesCollectionViewController.didMove(toParent: self)
        view.addConstraintsWithFormat(format: "V:[v0]-\(view.getCorrectSize(27, 27, 74))-[v1]|", views: customNavBar, devicesCollectionViewController.view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: devicesCollectionViewController.view)
    }
    
    func selectDevice(with data: DeviceData) {
        devicesCollectionViewController.selectDeviceWithUuid = data.uuid
        devicesCollectionViewController.fetchDevices()
    }
    
    func updateDeviceCounter(count : Int) {
        self.subtitleLabel.text = Localization.shared.devices_count_devices.doubleBracketReplace(with: "\(count)")
    }
}


extension DevicesViewController : UserSelectableTab {
    func tabDeselected() {
        
    }
    
    func userDidSelectTab() {
        devicesCollectionViewController.fetchDevices()
    }
}
