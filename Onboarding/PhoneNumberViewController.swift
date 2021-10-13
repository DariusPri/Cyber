//
//  PhoneNumberViewController.swift
//  Xpert
//
//  Created by Darius on 18/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit
import CountryPicker

class PhoneNumberViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
        
    // MARK:- Init
    
    init() {
        let backButton = BackNavButton()
        super.init(leftButton: backButton, rightButton: nil, title: Localization.shared.sign_up_to_dynarisk.doubleBracketReplace(with: "Dynarisk"), subtitle: nil)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        titleLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(20, 20, 28))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle
    
    var phoneInputField : SquareCountryTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setupPhoneInputView()
        setupMainStack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        phoneInputField?.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultValues()
    }
    
    // MARK: - Setup
    
    func setupHeader() -> HeaderLabel {
        let header = HeaderLabel(text: Localization.shared.phone_what_s_your_phone_number_+" ", edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        return header
    }
    
    func setupSignInButton() -> UIButton {
        let signUpButton = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        signUpButton.titleLabel?.font = signUpButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 21))
        signUpButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return signUpButton
    }
    
    func setupPhoneInputView() {
        phoneInputField = SquareCountryTextView(placeholderText: Localization.shared.phone_number)
        phoneInputField!.textField.font = phoneInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        phoneInputField!.placeholderLabel.font = phoneInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        phoneInputField!.translatesAutoresizingMaskIntoConstraints = false
        phoneInputField!.heightAnchor.constraint(equalToConstant: 55).isActive = true
        phoneInputField!.height = 55
        phoneInputField!.textField.heightConstraint?.constant = 55
        phoneInputField!.textField.layoutIfNeeded()
        phoneInputField!.leftConstraint?.constant = 100
    }
    
    func setDefaultValues() {
        if let code = (self.navigationController as? XpertNavigationController)?.registrationData?.countryCode, code.count > 0 {
            phoneInputField?.textField.text = (self.navigationController as? XpertNavigationController)?.registrationData?.phone_number
            phoneInputField?.textField.countryPicker?.setCountryByPhoneCode(code)
            phoneInputField?.setPlaceholder(on: false, animated: false)
        }
    }
    
    func setupMainStack() {
        let header = setupHeader()
        if view.isSmallScreenSize == false { header.textAlignment = .center }

        _ = [header, phoneInputField!, setupSignInButton()].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(14, 14, 14)
        mainStack.setCustomSpacing(view.getCorrectSize(25, 25, 25), after: header)
        mainStack.setCustomSpacing(24, after: phoneInputField!)
      
        mainScrollView.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: mainStack)
        } else {
            mainScrollView.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainStack)
        }

        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: view.getCorrectSize(48, 140, 200)).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func nextButtonAction() {
        presentError(viewModel: ErrorViewModel(errorText: nil))
        
        phoneInputField?.textField.text = phoneInputField?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let text = phoneInputField?.textField.text, let code = phoneInputField?.textField.countryPicker?.currentCountry?.phoneCode else { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.error_occured])); return }
        
        let totalCount = text.count + code.count
        if totalCount < 6 || totalCount > 15 { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.phone_must_contains])); return }
        
        let check = text.check()
        if check.hasLowerCase == true || check.hasSpecialCharacter || check.hasUpperCase { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.phone_must_contains])); return }
        
        (self.navigationController as? XpertNavigationController)?.registrationData?.phone_number = phoneInputField?.textField.text
        (self.navigationController as? XpertNavigationController)?.registrationData?.countryCode = phoneInputField?.textField.countryPicker?.currentCountry?.phoneCode
        self.navigationController?.pushViewController(PasswordViewController(), animated: true)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
