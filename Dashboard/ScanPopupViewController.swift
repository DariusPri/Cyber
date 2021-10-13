//
//  ScanPopupViewController.swift
//  Xpert
//
//  Created by Darius on 05/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ScanPopupViewController: PopupViewController {
    
    let scanCardVC : ScanCardViewController
    
    init(scanData : ScanData) {
        scanCardVC = ScanCardViewController(scanData: scanData)
        super.init(title: "", rightButton: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardVC()
        setupDottedLine()
    }
    
    func setupCardVC() {
        containerView.addSubview(scanCardVC.view)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: scanCardVC.view)
        containerView.addConstraintsWithFormat(format: "V:|-50-[v0]|", views: scanCardVC.view)
        addChild(scanCardVC)
        scanCardVC.didMove(toParent: self)
    }
    
    func setupDottedLine() {
        let dottedLineView = DottedLineView()
        scanCardVC.scanView.addSubview(dottedLineView)
        scanCardVC.scanView.addConstraintsWithFormat(format: "H:[v0(10)]", views: dottedLineView)
        NSLayoutConstraint(item: dottedLineView, attribute: .top, relatedBy: .equal, toItem: scanCardVC.scanView.detailedLabel, attribute: .bottom, multiplier: 1, constant: 25).isActive = true
        NSLayoutConstraint(item: dottedLineView, attribute: .bottom, relatedBy: .equal, toItem: scanCardVC.scanView.premiumButton, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dottedLineView, attribute: .centerX, relatedBy: .equal, toItem: scanCardVC.scanView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StatusButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 2
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setupButton(for status : ScanStatus) {
        if status == .enabled {
            setTitle("  \(Localization.shared.enabled.uppercased())  ", for: .normal)
            backgroundColor = UIColor(red: 114/255, green: 204/255, blue: 87/255, alpha: 1)
        } else {
            setTitle("  \(Localization.shared.disabled.uppercased())  ", for: .normal)
            backgroundColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
