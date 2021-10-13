//
//  NewDeviceNameCell.swift
//  Xpert
//
//  Created by Darius on 30/11/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class NewDeviceNameCell : UICollectionViewCell {
    
    let nameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = Localization.shared.add_device_name
        textField.font = UIFont(name: "Muli-Regular", size: 15)
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 233/255, alpha: 1).cgColor
        textField.layer.cornerRadius = 3
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 20))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        if #available(iOS 13.0, *) {
            textField.overrideUserInterfaceStyle = .light
        }
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameTextField)
        nameTextField.font = nameTextField.font?.withSize(getCorrectSize(15, 15, 21))
        addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: nameTextField)
        addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: nameTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
