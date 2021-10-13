//
//  SettngsViewController.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SettngsViewController: UIViewController, ErrorPresenter {
    
    let settingsCollectionViewController = SettingsCollectionViewController(collectionViewLayout: HowToCollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setupNav()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(settingsCollectionViewController.view)
        addChild(settingsCollectionViewController)
        settingsCollectionViewController.didMove(toParent: self)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: settingsCollectionViewController.view)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: settingsCollectionViewController.view)
    }
    
    var navShouldHide = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if navShouldHide == true { self.navigationController?.setNavigationBarHidden(true, animated: true) }
    }
    
    let backButton = UIButton()
    let titleLabel = UILabel()

    func setupNav() {
        let height = backButton.heightAnchor.constraint(equalToConstant: 30)
        height.priority = .init(rawValue: 777)
        height.isActive = true
        
        let width = backButton.widthAnchor.constraint(equalToConstant: 30)
        width.priority = .init(rawValue: 777)
        width.isActive = true
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(#imageLiteral(resourceName: "short_arrow_left_ic"), for: .normal)
        backButton.imageView?.tintColor = UIColor(named: "settingsNavBackButtonTintColor")
        backButton.layer.cornerRadius = 3
        backButton.backgroundColor = UIColor(named: "squareButtonColor")
        backButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(named: "defaultTextColor")
        titleLabel.text = Localization.shared.setting
        
        self.navigationItem.titleView = titleLabel
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func presentLogoutDueToBadToken() {
        presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
            DashboardViewController.logOutUserDueToBadToken()
        }
    }
    
    @objc func closeViewController() {
        navShouldHide = true
        settingsCollectionViewController.setEmailRadios { (success, isTokenValid) in
            
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.closeViewController()
                    } else {
                        self.presentLogoutDueToBadToken()
                    }
                })
            } else {
                if success == true {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {})
                    }
                }
            }
               
        }
    }
    
    
    func resetIfNeeded() {
         if #available(iOS 13.0, *) {
             self.traitCollection.performAsCurrent {
                self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
                self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
                backButton.backgroundColor = UIColor(named: "squareButtonColor")
                backButton.imageView?.tintColor = UIColor(named: "settingsActionButtonTintColor")
                titleLabel.textColor = UIColor(named: "defaultTextColor")
             }
         }
     }
     
     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         super.traitCollectionDidChange(previousTraitCollection)
         if #available(iOS 13.0, *) {
             guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
             resetIfNeeded()
         }
     }
}
