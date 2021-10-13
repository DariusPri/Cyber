//
//  DataViewController.swift
//  Xpert
//
//  Created by Darius on 22/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class DataViewController: NavViewController, ErrorPresenter {
        
    let dataCollectionViewController = DataCollectionViewController()
    
    init() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        super.init(leftButton: nil, rightButton: button, title: "\(Localization.shared.menu_data)", subtitle: "0 \(Localization.shared.active.capitalized) \(Localization.shared.data_emails)")
        subtitleLabel.font = subtitleLabel.font.withSize(view.getCorrectSize(12, 12, 16))
        button.heightAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "settings ic_max") : #imageLiteral(resourceName: "settings_ic"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emailInputView = EmailInputView()
    var emailInputViewWidth : NSLayoutConstraint?
    var horizontalInset : CGFloat = 0
    var errorViewContainer : UIView = ErrorContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setNeedsStatusBarAppearanceUpdate()
        view.addSubview(dataCollectionViewController.view)
        addChild(dataCollectionViewController)
        dataCollectionViewController.didMove(toParent: self)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: dataCollectionViewController.view)
        view.addConstraintsWithFormat(format: "V:[v0]-\(view.getCorrectSize(27, 27, 74))-[v1]|", views: customNavBar, dataCollectionViewController.view)
    }
    
    func changeEmailCounter(with count : Int, andCurrentIndex index : Int) {
        let singulars = [Localization.shared.data_email, Localization.shared.data_card, Localization.shared.data_phone]
        let plurals = [Localization.shared.data_emails, Localization.shared.data_cards, Localization.shared.data_phones]
        subtitleLabel.text = "\(count) \(Localization.shared.active.capitalized) \(count == 1 ? singulars[index] : plurals[index])"
        subtitleLabel.setNeedsLayout()
        subtitleLabel.layoutIfNeeded()
        subtitleLabel.sizeToFit()
    }
    
    @objc func familysMemberCheckboxAction() {
        emailInputView.checkBoxButton.isSelected = !emailInputView.checkBoxButton.isSelected
    }
    
}



extension DataViewController : UserSelectableTab {
    func tabDeselected() {
    
    }
    
    func userDidSelectTab() {
        dataCollectionViewController.output.fetchAllData()
    }
}
