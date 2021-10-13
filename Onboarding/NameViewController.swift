//
//  NameViewController.swift
//  Xpert
//
//  Created by Darius on 26/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class NameViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {

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
    
    var firstNameInputField : SquareTextView?
    var lastnameInputField : SquareTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        let header = HeaderLabel(text: Localization.shared.name_what_s_your_name_, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        if view.isSmallScreenSize == false { header.textAlignment = .center }

        firstNameInputField = SquareTextView(placeholderText: Localization.shared.first_name)
        firstNameInputField!.textField.font = firstNameInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        firstNameInputField!.placeholderLabel.font = firstNameInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        firstNameInputField!.translatesAutoresizingMaskIntoConstraints = false
        firstNameInputField!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        
        lastnameInputField = SquareTextView(placeholderText: Localization.shared.last_name)
        lastnameInputField!.textField.font = lastnameInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        lastnameInputField!.placeholderLabel.font = lastnameInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        lastnameInputField!.translatesAutoresizingMaskIntoConstraints = false
        lastnameInputField!.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        
        let signUpButton = SquareButton(title: Localization.shared.next.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        signUpButton.titleLabel?.font = signUpButton.titleLabel?.font.withSize(15)
        signUpButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 55)).isActive = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        
        _ = [header, firstNameInputField!, lastnameInputField!, signUpButton].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(14, 14, 14)
        mainStack.setCustomSpacing(view.getCorrectSize(25, 25, 25), after: header)
        mainStack.setCustomSpacing(24, after: lastnameInputField!)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultValues()
    }
    
    func setDefaultValues() {
        firstNameInputField?.textField.text = (self.navigationController as? XpertNavigationController)?.registrationData?.first_name
        lastnameInputField?.textField.text = (self.navigationController as? XpertNavigationController)?.registrationData?.last_name

        if firstNameInputField?.textField.text?.count ?? 0 > 0 { firstNameInputField?.setPlaceholder(on: false, animated: false) }
        if lastnameInputField?.textField.text?.count ?? 0 > 0 { lastnameInputField?.setPlaceholder(on: false, animated: false) }
    }
    
    @objc func nextButtonAction() {
        
        firstNameInputField?.textField.text = (firstNameInputField?.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        lastnameInputField?.textField.text = (lastnameInputField?.textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let text = firstNameInputField?.textField.text, text.count > 0 else { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.name_is_required])); return }
        guard let count = lastnameInputField?.textField.text, count.count > 0 else { presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.last_name_is_required])); return }

        var errors : [String] = []
        
        let check = text.check()
        
        if check.hasSpecialCharacter == true || check.hasNumber == true {
            errors.append(Localization.shared.name_can_t_use_special_characters)
        }

        if text.count < 2 { errors.append(Localization.shared.name_can_t_be_less_than_2_characters) }
        
        presentError(viewModel: ErrorViewModel(errorText: errors.count == 0 ? nil : errors))
    
        if errors.count == 0 {
            (self.navigationController as? XpertNavigationController)?.registrationData?.first_name = firstNameInputField!.textField.text
            (self.navigationController as? XpertNavigationController)?.registrationData?.last_name = lastnameInputField!.textField.text
            self.navigationController?.pushViewController(PhoneNumberViewController(), animated: true)
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
