//
//  VerifyEmailViewController.swift
//  Xpert
//
//  Created by Darius on 27/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController, ErrorPresenter, NotLoggedInViewProtocol {

    // MARK:- View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setupMainStack()
    }
    
    // MARK:- Setup
    
    func setupMainStack() {
        let mainStack = UIStackView(arrangedSubviews: [setupDetailedView(), setupFirtButton(), /* setupSecondButton() this didn't seem rational */ setupThirdButton()])
        mainStack.spacing = view.getCorrectSize(25, 25, 34)
        mainStack.alignment = .center
        mainStack.axis = .vertical
        
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(min(view.calculatedNewScreenWidth, 520)))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }

    func setupDetailedView() -> DetailedView {
        let detailedView = DetailedView(image: #imageLiteral(resourceName: "email_ill_dark"), header: Localization.shared.verify_verify_your_email, subheader: Localization.shared.an_activation_link_has_been_sent)
        detailedView.headerLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(26, 26, 34))
        detailedView.subheaderLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(17, 17, 22))
        return detailedView
    }
    
    func setupFirtButton() -> TextButton {
        let button1 = TextButton(title: Localization.shared.resend_activation_email.uppercased())
        button1.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: view.getCorrectSize(10, 10, 14))
        button1.addTarget(self, action: #selector(resendActivationEmail), for: .touchUpInside)
        button1.heightAnchor.constraint(equalToConstant: 13).isActive = true
        return button1
    }
    
    func setupSecondButton() -> TextButton {
        let button2 = TextButton(title: Localization.shared.edit_email.uppercased())
        button2.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: view.getCorrectSize(10, 10, 14))
        button2.heightAnchor.constraint(equalToConstant: 13).isActive = true
        button2.addTarget(self, action: #selector(pushEditEmailVC), for: .touchUpInside)
        return button2
    }
    
    func setupThirdButton() -> TextButton {
        let button3 = TextButton(title: Localization.shared.navigate_to_login.uppercased())
        
        button3.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: view.getCorrectSize(10, 10, 14))
        button3.heightAnchor.constraint(equalToConstant: 13).isActive = true
        button3.addTarget(self, action: #selector(backToLogin), for: .touchUpInside)
        return button3
    }
    
    @objc func backToLogin() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func pushEditEmailVC() {
        self.navigationController?.pushViewController(EditEmailViewController(), animated: true)
    }
    
    @objc func resendActivationEmail(sender : UIButton) {
        sender.isEnabled = false
        resendActivation { (success) in
            DispatchQueue.main.async {
                if success == true {
                    self.presentSuccessfulCenterPopup(withIcon: nil, andTitle: Localization.shared.we_sent_an_activation_email_header, andSubtitle: Localization.shared.we_sent_an_activation_email_subheader)
                } else {
                    self.presentSimpleOKError(withTitle: Localization.shared.error, andSubtitle: Localization.shared.error_occured, completion: {})
                }
            }
        }
    }

    
    func resendActivation(completion: @escaping (Bool) -> ()) {
        guard let email = (self.navigationController as? XpertNavigationController)?.registrationData?.email else { completion(false); return }
        guard let url = CyberExpertAPIEndpoint.resendActivation.url() else { completion(false); return }
        
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "email": email
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, response, error) in
            completion(error == nil && (response as? HTTPURLResponse)?.statusCode == 200)
        }
        
    }
}
