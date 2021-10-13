//
//  TextInputViewController.swift
//  Xpert
//
//  Created by Darius on 2020-01-15.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class TextInputViewController: NavViewController, ErrorPresenter {
    
    let textInputCVController : TextInputCollectionViewController
    var textInputCVContainerHeightConstraint : NSLayoutConstraint?
    
    init(data : [TextInputCollectionViewController.TextInputData]) {
        textInputCVController = TextInputCollectionViewController(data:data)
        super.init(leftButton: nil, rightButton: nil, title: nil, subtitle: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        customNavBar.removeFromSuperview()
        
        mainStack.axis = .vertical
        mainStack.spacing = 25

        addChild(textInputCVController)
        textInputCVController.didMove(toParent: self)
        
        let textInputCVContainerView = UIView()
        textInputCVContainerView.addSubview(textInputCVController.view)
        textInputCVContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: textInputCVController.view)
        textInputCVContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: textInputCVController.view)
        
        textInputCVContainerHeightConstraint = textInputCVContainerView.heightAnchor.constraint(equalToConstant: (50.0 + 56.0) * CGFloat(textInputCVController.textInputArray.count))
        textInputCVContainerHeightConstraint?.isActive = true
        
        mainStack.addArrangedSubview(textInputCVContainerView)
        
        mainScrollView.addSubview(mainStack)
        mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=600)]-(>=15,==15@900)-|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        view.addConstraintsWithFormat(format: "V:|[v0]", views: mainScrollView)

        setupNav()
    }
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Localization.shared.personal_information
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        return titleLabel
    }()
    
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.shared.save.uppercased(), style: .plain, target: self, action: #selector(saveButtonAction))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .highlighted)
        
        self.navigationItem.titleView = headerLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textInputCompletionData : (([TextInputCollectionViewController.TextInputData])->())?

    @objc func saveButtonAction() {
        
        self.presentError(viewModel: ErrorViewModel(errorText: nil))

        func checkIfSpecialCharactersExist(for string : String) -> Bool {
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            if string.rangeOfCharacter(from: characterset.inverted) != nil {
                return true
            }
            return false
        }
                            
        for i in 0..<textInputCVController.textInputArray.count {
            let ip = IndexPath(item: 0, section: i)
            let cell = textInputCVController.collectionView?.cellForItem(at: ip) as! TextInputCell
            cell.inputTextField.text = cell.inputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            textInputCVController.textInputArray[i].value = cell.inputTextField.text ?? ""
        }
        
        var errors : [String] = []

        for (i, _) in textInputCVController.textInputArray.enumerated() {
            let text = textInputCVController.textInputArray[i].value
            switch textInputCVController.textInputArray[i].inputType {
            case .firstName:
                if text.count == 0 { errors.append(Localization.shared.name_is_required) } else if text.count < 3 { errors.append(Localization.shared.name_can_t_be_less_than_3_characters) } else if checkIfSpecialCharactersExist(for: text) == true { errors.append(Localization.shared.name_can_t_use_special_characters) }
            case .lastName:
                if text.count == 0 { errors.append(Localization.shared.last_name_is_required) }
            case .email:
                if text.count == 0 { errors.append(Localization.shared.email_is_required) } else if text.isValidEmail() == false { errors.append(Localization.shared.onboarding_bad_email_format)}
            default:
                break
            }
        }
        
        if errors.count == 0 {
            textInputCompletionData?(textInputCVController.textInputArray)
        } else {
            self.presentError(viewModel: ErrorViewModel(errorText: errors))
        }
        
    }
    
    @objc func closeViewController() { self.navigationController!.dismiss(animated: true, completion: nil) }
}
