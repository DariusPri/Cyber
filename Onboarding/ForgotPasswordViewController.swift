//
//  ForgotPasswordViewController.swift
//  Xpert
//
//  Created by Darius on 27/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
    
    // MARK:- Init
    
    let emailInputField = SquareTextView(placeholderText: Localization.shared.email_address)

    init() {
        let backButton = BackNavButton()
        super.init(leftButton: backButton, rightButton: nil, title: Localization.shared.forgot_find_your_password, subtitle: nil)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        setupEmailField()
        setupMainStack()
        
    }
    
    // MARK:- Setup UI
    
    func setupSignUpButton() -> SquareButton {
        let signUpButton = SquareButton(title: Localization.shared.forgot_recover_password.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        signUpButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(resetPasswodAction), for: .touchUpInside)
        return signUpButton
    }
    
    func setupMainStack() {
        let signUpButton = setupSignUpButton()
        _ = [emailInputField, signUpButton].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = 14
        
        view.addSubview(mainStack)
        view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }

    func setupEmailField() {
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.heightAnchor.constraint(equalToConstant: 54).isActive = true
        emailInputField.textField.font = emailInputField.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        emailInputField.textField.keyboardType = .emailAddress
        emailInputField.placeholderLabel.font = emailInputField.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
    }
    
    @objc func resetPasswodAction() {
        let errors : [String]? = emailInputField.textField.text == "" ? [Localization.shared.onboarding_can_t_leave_email_empty] : (emailInputField.textField.text?.isValidEmail() == true ? nil : [Localization.shared.onboarding_bad_email_format])
        self.presentError(viewModel: ErrorViewModel(errorText: errors?.count == 0 ? nil : errors))
        if errors == nil || errors?.count == 0 {
            sendPasswordToEmail { (errorArray) in
                if let errorList = errorArray, errorList.count > 0 {
                    self.presentError(viewModel: ErrorViewModel(errorText: errorList))
                } else {
                    self.presentError(viewModel: ErrorViewModel(errorText: nil))
                    self.navigationController?.pushViewController(PasswordResetSuccessViewController(), animated: true)
                }
            }
        }
    }
    
    
    func sendPasswordToEmail(completion: @escaping ([String]?) -> ()) {
        guard let email = emailInputField.textField.text?.lowercased() else { return }
        guard let url = CyberExpertAPIEndpoint.forgotPassword.url() else { return completion([Localization.shared.server_error]) }
                
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "PUT"
        
        let parameters: [String: Any] = [
            "email": email
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, response, error) in
        
            // it seems we don't show errors for this request
            
            guard let _ = data else { completion([Localization.shared.reset_password_error]); return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(nil)
            } else {
                completion([Localization.shared.server_error])
            }
        }
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
