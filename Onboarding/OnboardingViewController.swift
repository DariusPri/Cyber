//
//  OnboardingViewController.swift
//  Xpert
//
//  Created by Darius on 25/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class OnboardingViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
    
    // MARK :- Init
    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: Localization.shared.sign_up_to_dynarisk.doubleBracketReplace(with: "Dynarisk"), subtitle: nil)
        titleLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(20, 20, 28))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setup()
    }
    
    // MARK: - Setup
    
    var emailInputField : SquareTextView?
    
    private func setup() {
        
        self.hideKeyboardWhenTappedAround()

        let signInButton = SquareButton(title: Localization.shared.got_an_account.uppercased()+" "+Localization.shared.sign_in.uppercased(), image: nil, backgroundColor: UIColor(named: "secondaryButtonColor")!, textColor: UIColor(named: "secondaryButtonTextColor")!)
        signInButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 15)
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        view.addSubview(signInButton)
        
        let guide = self.view.safeAreaLayoutGuide
        signInButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(55, 55, 55)).isActive = true
        
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: signInButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: signInButton)
        }
        
        NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
        let header = HeaderLabel(text: Localization.shared.onboarding_what_s_your_email_, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        if view.isSmallScreenSize == false { header.textAlignment = .center }
        
        emailInputField = SquareTextView(placeholderText: Localization.shared.email_address)
        emailInputField!.textField.keyboardType = .emailAddress
        emailInputField!.textField.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(15, 15, 20))
        emailInputField!.placeholderLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(13, 13, 18))
        emailInputField!.translatesAutoresizingMaskIntoConstraints = false
        emailInputField!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        
        let signUpButton = SquareButton(title: Localization.shared.sign_up.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        signUpButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 15)
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true 

        _ = [header, emailInputField!, signUpButton].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(14, 14, 20)
        mainStack.setCustomSpacing(view.getCorrectSize(25, 25, 36), after: header)
        
        mainScrollView.addSubview(mainStack)
        
        if view.isSmallScreenSize == true {
            mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: mainStack)
        } else {
            mainScrollView.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: view.getCorrectSize(48, 140, 200) ).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }

    // MARK: - Event handling

    /// register with Email
    @objc func signUpAction(sender : UIButton) {
        let errors : [String]? = emailInputField?.textField.text == "" ? [Localization.shared.onboarding_can_t_leave_email_empty] : (emailInputField?.textField.text?.isValidEmail() == true ? nil : [Localization.shared.onboarding_bad_email_format])
        self.presentError(viewModel: ErrorViewModel(errorText: errors?.count == 0 ? nil : errors))
        
        if errors == nil || errors?.count == 0 {
            sender.isEnabled = false

            checkIfEmailIsTaken { (errorArray) in
                if let errorList = errorArray, errorList.count > 0 {
                    self.presentError(viewModel: ErrorViewModel(errorText: errorList))
                    sender.isEnabled = true
                } else {
                    self.presentError(viewModel: ErrorViewModel(errorText: nil))
                    if (self.navigationController as! XpertNavigationController).registrationData == nil {
                        (self.navigationController as! XpertNavigationController).registrationData = RegistrationData()
                    }
                    (self.navigationController as? XpertNavigationController)!.registrationData?.email = self.emailInputField?.textField.text?.lowercased()
                    self.navigationController?.pushViewController(NameViewController(), animated: true)
                    sender.isEnabled = true 
                }
            }
        }
    }
    
    @objc func signInAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkIfEmailIsTaken(completion: @escaping ([String]?) -> ()) {
        guard let email = emailInputField?.textField.text?.lowercased() else { return }
        guard let url = CyberExpertAPIEndpoint.validateEmail.url() else { completion([Localization.shared.error_occured]); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "email" : email
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, response, error) in
                                    
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                if let violations = json?["violations"] as? [[String : Any]] {
                    for violation in violations {
                        if let type = violation["type"] as? String, type == "urn:uuid:359c554f-d6de-42a0-ae93-6cd97f1c8dfe" {
                            completion([Localization.shared.email_in_use])
                            return
                        }
                    }
                }
                completion(nil)
                return
            }
        }
    }
}

