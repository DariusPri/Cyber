//
//  ActivateDeviceViewController.swift
//  Xpert
//
//  Created by Darius on 27/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ActivateDeviceViewController: ScanSlideViewController {
    
    let activateDeviceButton = SquareButton(title: Localization.shared.assessment_start.uppercased(), image: nil, backgroundColor: UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1), textColor: .white)
    
    let deviceData : DeviceData
    
    init(deviceData : DeviceData) {
        self.deviceData = deviceData
        
        super.init(image: #imageLiteral(resourceName: "phone_activate_ill"), header: Localization.shared.device_activating_device_name_.doubleBracketReplace(with: deviceData.name), subheader: Localization.shared.device_assessment_subheader, animationName: nil, explainerText: nil)
        detailedView.mainStack.setCustomSpacing(40, after: detailedView.mainImageView)
        NSLayoutConstraint(item: detailedView.headerLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: detailedView.subheaderLabel, attribute: .width, multiplier: 1, constant: -50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNextButton()
        setMainImage()
        verticalCenterLayout!.constant = view.getCorrectSize(-48, -48, -250)
        detailedView.mainImageViewHeightConstraint.constant = view.getCorrectSize(160, 160, 226)
        detailedView.mainImageViewWidthContraint.constant = view.getCorrectSize(149, 149, 206)
    }
    
    func setMainImage() {
        
        switch DeviceType(string: deviceData.type) {
        case .phone:
            detailedView.mainImageView.image = view.isHugeScreenSize == true ? #imageLiteral(resourceName: "phone_activate_ill_huge") : #imageLiteral(resourceName: "phone_activate_ill")
        case .laptop:
            detailedView.mainImageView.image = view.isHugeScreenSize == true ? #imageLiteral(resourceName: "laptop_scan_ill_huge") : #imageLiteral(resourceName: "laptop_scan_ill")
        case .tablet:
            detailedView.mainImageView.image = view.isHugeScreenSize == true ? #imageLiteral(resourceName: "tablet_activate_ill_huge") : #imageLiteral(resourceName: "tablet_activate_ill")
        case .desktop:
            detailedView.mainImageView.image = view.isHugeScreenSize == true ? #imageLiteral(resourceName: "pc_activate_ill_huge") : #imageLiteral(resourceName: "pc_activate_ill")
        default:
            detailedView.mainImageView.image = nil
        }
    }
    
    func addNextButton() {
        view.addSubview(activateDeviceButton)
        let guide = self.view.safeAreaLayoutGuide
        activateDeviceButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        activateDeviceButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(55, 55, 80)).isActive = true
        activateDeviceButton.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: view.getCorrectSize(15, 15, 21))
        NSLayoutConstraint(item: activateDeviceButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: activateDeviceButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: activateDeviceButton)
        }
    }
    
    @objc func closeViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
