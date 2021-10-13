//
//  TextInputCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 10/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TextInputCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    enum TextInputType : String {
        case firstName = "FIRST NAME"
        case lastName = "LAST NAME"
        case email = "EMAIL ADRESS"
        case recoveryEmail = "RECOVERY EMAIL"
        case oldPass = "OLD PASSWORD"
        case newPass = "NEW PASSWORD"
        case retypeNewPass = "RETYPE NEW PASSWORD"
        
        func localized() -> String {
            switch self {
            case .firstName:
                return Localization.shared.first_name.uppercased()
            case .lastName:
                return Localization.shared.last_name.uppercased()
            case .email:
                return Localization.shared.email_address.uppercased()
            case .recoveryEmail:
                return Localization.shared.recovery_email.uppercased()
            case .oldPass:
                return Localization.shared.old_password.uppercased()
            case .newPass:
                return Localization.shared.new_password.uppercased()
            case .retypeNewPass:
                return Localization.shared.repeat_new_password.uppercased()
            }
        }
    }
    
    struct TextInputData {
        var inputType : TextInputType
        var placeholder : String
        var value : String
        var isOptional : Bool
        var isEnabled : Bool
    }
    
    var textInputArray : [TextInputData] = []
    
    init(data : [TextInputData]) {
        textInputArray = data
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.reloadData()
        self.view.backgroundColor = .clear
        self.collectionView!.backgroundColor = .clear
        self.collectionView!.register(TextInputCell.self, forCellWithReuseIdentifier: "TextInputCell")
        self.collectionView!.register(InputHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InputHeaderView")
        self.collectionView?.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return textInputArray.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextInputCell", for: indexPath) as! TextInputCell
        cell.inputTextField.placeholder = textInputArray[indexPath.section].placeholder
        cell.inputTextField.text = textInputArray[indexPath.section].value
        let types : [TextInputCollectionViewController.TextInputType] = [.newPass, .oldPass, .retypeNewPass]
        if types.contains(textInputArray[indexPath.section].inputType) == true {
            cell.inputTextField.isSecureTextEntry = true
            if #available(iOS 12.0, *) { cell.inputTextField.passwordRules = UITextInputPasswordRules(descriptor: "") }
        } else {
            cell.inputTextField.isSecureTextEntry = false
            if #available(iOS 12.0, *) { cell.inputTextField.passwordRules = nil }
        }
        cell.inputTextField.isEnabled = textInputArray[indexPath.section].isEnabled
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 30, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "InputHeaderView", for: indexPath) as! InputHeaderView
        header.titleLabel.font = UIFont(name: "Muli-ExtraBold", size: 12)
        header.titleLabel.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        header.titleLabel.text = textInputArray[indexPath.section].inputType.localized()
        header.titleLabel.sizeToFit()
        header.optionalLabel.alpha = textInputArray[indexPath.section].isOptional == true ? 1 : 0
        header.layoutIfNeeded()
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 56)
    }

}


