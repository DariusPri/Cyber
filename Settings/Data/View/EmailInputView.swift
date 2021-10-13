//
//  EmailInputView.swift
//  Xpert
//
//  Created by Darius on 22/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class EmailInputView: UIView {
    
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Muli-Regular", size: 15)
        textField.textColor = UIColor(named: "dataInputViewTextColor")
        return textField
    }()
    
    let phoneInputField = SquareCountryTextView(placeholderText: Localization.shared.phone_number)

    
    let actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "dataInputButtonColor")
        button.imageView?.tintColor = UIColor(named: "dataInputButtonTintColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        return button
    }()
    
    let checkBoxButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "familycheck_unchecked_ic"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "familycheck_checked_ic"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Localization.shared.is_family_member, for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Muli-Regular", size: 13)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(selectCheckboxButton), for: .touchUpInside)
        return button
    }()
    
    @objc func selectCheckboxButton() {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        checkBoxButton.titleEdgeInsets = .init(top: 0, left: getCorrectSize(12, 12, 22), bottom: 0, right: 0)
        actionButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "arrow_right_blue_huge") : #imageLiteral(resourceName: "arrow_right_blue"), for: .normal)
        emailTextField.font = emailTextField.font?.withSize(getCorrectSize(15, 15, 21))
        checkBoxButton.titleLabel?.font = checkBoxButton.titleLabel?.font.withSize(getCorrectSize(13, 13, 18))
        
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.textInputBorderColor.cgColor

        setupView(forIndex: 0)
    }
    
    func setupView(forIndex index : Int) {
        
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        let topContainerView = UIView()
        addSubview(topContainerView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: topContainerView)
        
        var emailImageView : UIImageView
        
        switch index {
        case 1:
            topContainerView.bringSubviewToFront(emailTextField)

            emailTextField.attributedPlaceholder = NSAttributedString(string: "\(Localization.shared.card_number.capitalized)....", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "dataInputViewTextColor")!])
            emailTextField.placeholder = Localization.shared.card_number+"..."

            emailTextField.keyboardType = .default
            emailImageView = UIImageView(image: isHugeScreenSize == true ? #imageLiteral(resourceName: "creditadd_ic_huge") : #imageLiteral(resourceName: "creditadd_ic"))
            addConstraintsWithFormat(format: "V:|[v0(\(getCorrectSize(64, 64, 86)))]|", views: topContainerView)
            break
        case 2:
            topContainerView.bringSubviewToFront(phoneInputField)
            phoneInputField.height = getCorrectSize(64, 64, 86)
            phoneInputField.textField.heightConstraint?.constant = getCorrectSize(64, 64, 86)
            phoneInputField.layer.borderColor = UIColor.clear.cgColor
            phoneInputField.textField.layoutIfNeeded()
            emailImageView = UIImageView(image: isHugeScreenSize == true ? #imageLiteral(resourceName: "phoneadd_ic_huge") : #imageLiteral(resourceName: "phoneadd_ic"))
            addConstraintsWithFormat(format: "V:|[v0(\(getCorrectSize(64, 64, 86)))]|", views: topContainerView)
            break
        default:
            topContainerView.bringSubviewToFront(emailTextField)

            emailTextField.attributedPlaceholder = NSAttributedString(string: "\(Localization.shared.email_address.capitalized)....", attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "dataInputViewTextColor")!])
            emailTextField.placeholder = Localization.shared.email_address+"..."
            emailTextField.keyboardType = .emailAddress
            
            emailImageView = UIImageView(image: isHugeScreenSize == true ? #imageLiteral(resourceName: "emailadd_ic_huge") : #imageLiteral(resourceName: "emailadd_ic"))
            emailImageView.contentMode = .scaleAspectFit

            let bottomContainerView = UIView()
            let line = UIView()
            line.backgroundColor = UIColor(white: 0.9, alpha: 1)
            
            addSubview(line)
            addSubview(bottomContainerView)
            
            addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 32))-[v0]-\(getCorrectSize(20, 20, 32))@777-|", views: line)
            addConstraintsWithFormat(format: "H:|[v0]|", views: bottomContainerView)
            addConstraintsWithFormat(format: "V:|[v0(\(getCorrectSize(64, 64, 86)))]-0@777-[v1(\(getCorrectSize(1, 1.4, 1.4)))][v2(\(getCorrectSize(56, 56, 74)))]|", views: topContainerView, line, bottomContainerView)

            bottomContainerView.addSubview(checkBoxButton)
            
            bottomContainerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 34))-[v0]-\(getCorrectSize(20, 20, 24))-|", views: checkBoxButton)
            NSLayoutConstraint(item: checkBoxButton, attribute: .centerY, relatedBy: .equal, toItem: bottomContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            checkBoxButton.heightAnchor.constraint(equalToConstant: getCorrectSize(18, 18, 18)).isActive = true
        }
        
        topContainerView.addSubview(actionButton)
        
        if index == 2 {
            topContainerView.addSubview(phoneInputField)
            topContainerView.addConstraintsWithFormat(format: "H:|-0@777-[v0]-\(getCorrectSize(10, 10, 16))-[v1(\(getCorrectSize(30, 30, 38)))]-\(getCorrectSize(20, 20, 28))-|", views: phoneInputField, actionButton)
            NSLayoutConstraint(item: phoneInputField, attribute: .centerY, relatedBy: .equal, toItem: topContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            topContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: phoneInputField)
        } else {
            emailImageView.contentMode = .scaleAspectFit
            topContainerView.addSubview(emailImageView)
            topContainerView.addSubview(emailTextField)
            topContainerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 28))-[v0(\(getCorrectSize(24, 24, 27)))]-\(getCorrectSize(12, 12, 18))@777-[v1]-\(getCorrectSize(10, 10, 16))-[v2(\(getCorrectSize(30, 30, 38)))]-\(getCorrectSize(20, 20, 28))-|", views: emailImageView, emailTextField, actionButton)
            NSLayoutConstraint(item: emailTextField, attribute: .centerY, relatedBy: .equal, toItem: topContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: emailImageView, attribute: .centerY, relatedBy: .equal, toItem: topContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            topContainerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(24, 24, 27)))]", views: emailImageView)
        }

        topContainerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(30, 30, 38)))]", views: actionButton)
        NSLayoutConstraint(item: actionButton, attribute: .centerY, relatedBy: .equal, toItem: topContainerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
