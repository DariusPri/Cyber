//
//  SupportViewController.swift
//  Xpert
//
//  Created by Darius on 31/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class SupportViewController: NavViewController {
    
    let supportCollectionViewController = SupportCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

    init() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        super.init(leftButton: nil, rightButton: button, title: Localization.shared.menu_support, subtitle: nil)
        button.heightAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        button.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "settings ic_max") : #imageLiteral(resourceName: "settings_ic"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        addChild(supportCollectionViewController)
        supportCollectionViewController.didMove(toParent: self)
        view.addSubview(supportCollectionViewController.view)
        view.addConstraintsWithFormat(format: "V:[v0]-27-[v1]|", views: customNavBar, supportCollectionViewController.view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: supportCollectionViewController.view)
        NSLayoutConstraint(item: supportCollectionViewController.view!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension SupportViewController : UserSelectableTab {
    func tabDeselected() {
        
    }
    
    func userDidSelectTab() {
      
    }

}
