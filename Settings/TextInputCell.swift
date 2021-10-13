//
//  TextInputCell.swift
//  Xpert
//
//  Created by Darius on 11/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class InputTextField : UITextField {
    
    override var isEnabled: Bool {
        willSet {
            backgroundColor = newValue ? UIColor.white : UIColor.gray.withAlphaComponent(0.1)
            textColor = newValue ? defaultTextColor : UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 0.2)
        }
    }
    
    let defaultTextColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 233/255, alpha: 1).cgColor
        layer.borderWidth = 1
        textColor = defaultTextColor
        font = UIFont(name: "Muli-Regular", size: 15)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 40))
        leftViewMode = .always
        attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)])
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TextInputCell: UICollectionViewCell {
    
    let inputTextField = InputTextField(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(inputTextField)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: inputTextField)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
