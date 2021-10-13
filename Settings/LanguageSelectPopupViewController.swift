//
//  LanguageSelectPopupViewController.swift
//  Xpert
//
//  Created by Darius on 2020-01-15.
//  Copyright © 2020. All rights reserved.
//

import UIKit

final class LanguageSelectPopupViewController: PopupViewController {
    
    let languageCV = LanguageSelectCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    let navigationBar = UINavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(languageCV)
        languageCV.didMove(toParent: self)
        containerView.addSubview(languageCV.view)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: languageCV.view)
        headerView.removeFromSuperview()
        addNavigationBar()
    }
    
    func addNavigationBar() {
        let leftData : WhiteNavigationBar.BarButtonData? = WhiteNavigationBar.BarButtonData(title: Localization.shared.cancel.uppercased(), color: UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1), target: self, selector: #selector(closeViewController))
        let rightData : WhiteNavigationBar.BarButtonData? = WhiteNavigationBar.BarButtonData(title: Localization.shared.save.uppercased(), color: UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1), target: self, selector: #selector(saveButtonAction))
        let navigationBar  = WhiteNavigationBar(header: Localization.shared.personal_information, leftButtonData: leftData, rightButtonData: rightData)
        
        containerView.addSubview(navigationBar)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: navigationBar)
        containerView.addConstraintsWithFormat(format: "V:[v0][v1]|", views: navigationBar, languageCV.view)
    }
    
    @objc func saveButtonAction() {
        languageCV.saveButtonAction()
    }
    
    @objc func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}
