//
//  PasswordResetSuccessViewController.swift
//  Xpert
//
//  Created by Darius on 2019-08-20.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class PasswordResetSuccessViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
            
    // MARK:- Init
    
    init() {
        let backButton = BackNavButton()
        super.init(leftButton: backButton, rightButton: nil, title: Localization.shared.forgot_password.capitalized, subtitle: nil)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setupMainStack()
    }
    
    func setupDetailedView() -> DetailedView {
        let detailedView = DetailedView(image: #imageLiteral(resourceName: "email_ill_dark"), header: Localization.shared.reset_password_sent, subheader: Localization.shared.reset_password_sent_subheader)
        detailedView.headerLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(26, 26, 34))
        detailedView.subheaderLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(17, 17, 22))
        return detailedView
    }
    
    func setupMainStack() {
        let detailedView = setupDetailedView()
        let mainStack = UIStackView(arrangedSubviews: [detailedView])
        mainStack.spacing = view.getCorrectSize(25, 25, 34)
        mainStack.alignment = .center
        mainStack.axis = .vertical
               
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(min(view.calculatedNewScreenWidth, 520)))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: view.getCorrectSize(100, 100, 100)).isActive = true
        detailedView.headerLabel.preferredMaxLayoutWidth = view.isSmallScreenSize == true ? 260 : 400
    }

    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
