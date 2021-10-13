//
//  EditEmailViewController.swift
//  Xpert
//
//  Created by Darius on 27/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class EditEmailViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
    
    // MARK:- Init
    
    init() {
        let backButton = BackNavButton()
        super.init(leftButton: backButton, rightButton: nil, title: Localization.shared.edit_email, subtitle: nil)
        backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let emailInputField = SquareTextView(placeholderText: Localization.shared.email_address)

    
    // MARK:- View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        setupEmailInputField()
        setupMainStack()
    }
    
    // MARK:- Setup UI
    
    func setupMainStack() {
        
        let header = setupHeader()
        
        _ = [header, emailInputField, setupNextButton()].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = 16
        mainStack.setCustomSpacing(view.getCorrectSize(24, 24, 36), after: header)

        view.addSubview(mainStack)
        view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: 54).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
    }
    
    func setupHeader() -> HeaderLabel {
        let header = HeaderLabel(text: Localization.shared.edit_what_s_your_email_, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        if view.isSmallScreenSize == false { header.textAlignment = .center }
        return header
    }
    
    func setupNextButton() -> SquareButton {
        let nextButton = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor.primaryButtonColor, textColor: .white)
        nextButton.addTarget(self, action: #selector(push), for: .touchUpInside)
        nextButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return nextButton
    }
    
    func setupEmailInputField() {
        emailInputField.textField.keyboardType = .emailAddress
        emailInputField.translatesAutoresizingMaskIntoConstraints = false
        emailInputField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailInputField.textField.font = emailInputField.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        emailInputField.placeholderLabel.font = emailInputField.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        emailInputField.textField.text = (self.navigationController as? XpertNavigationController)?.registrationData?.email
    }


    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func push() {
        
        emailInputField.textField.text = emailInputField.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let text = emailInputField.textField.text, text.count > 0 else { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.login_email_address_field_is_empty_])); return }
        
        if text.isValidEmail() == true {
            presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.onboarding_bad_email_format]))
            return
        }
        
        (self.navigationController as? XpertNavigationController)?.registrationData?.email = emailInputField.textField.text
        self.navigationController?.popViewController(animated: true)
    }

}
