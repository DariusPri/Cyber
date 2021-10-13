//
//  RadioButtonView.swift
//  Xpert
//
//  Created by Darius on 30/01/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class RadioButtonView: UIView {
    
    let mainStack = UIStackView()
    
    var selectedOptionCompletion : ((Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        let height = heightAnchor.constraint(equalToConstant: 50)
        height.priority = .init(777)
        height.isActive = true
        
        mainStack.spacing = 10
        mainStack.distribution = .fillEqually
        
        for (i, title) in [Localization.shared.data_emails.uppercased(), Localization.shared.data_cards.uppercased(), Localization.shared.data_phones.uppercased()].enumerated() {
            let b = RadioButton(frame: .zero)
            b.setTitle(title, for: .normal)
            b.index = i
            b.addTarget(self, action: #selector(selected(sender:)), for: .touchUpInside)
            mainStack.addArrangedSubview(b)
        }
        
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: mainStack)
        addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: mainStack)
        
        selected(sender: mainStack.arrangedSubviews.first as! RadioButton)
    }
    
    @objc func selected(sender : RadioButton) {
        for button in mainStack.arrangedSubviews {
            if let b = button as? RadioButton {
                b.isSelected = false
                b.selected(false)
            }
        }
        sender.isSelected = true
        sender.selected(true)
        selectedOptionCompletion?(sender.index)
    }
    
    func setSelected(at index : Int) {
        for button in mainStack.arrangedSubviews {
            if let b = button as? RadioButton {
                b.isSelected = false
                b.selected(false)
            }
        }
        if let selectedButton = mainStack.arrangedSubviews[index] as? RadioButton {
            selectedButton.isSelected = true
            selectedButton.selected(true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RadioButton: UIButton {
    
    var index : Int = 0
    let bottomLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont(name: "Muli-Bold", size: 14)
        setTitleColor(UIColor(named: "dataTabDeselectedTextColor"), for: .normal)
        setTitleColor(UIColor(named: "dataTabColor"), for: .selected)
        
        bottomLine.backgroundColor = UIColor(named: "dataTabColor")
        addSubview(bottomLine)
        addConstraintsWithFormat(format: "H:|[v0]|", viewsArray: [bottomLine])
        addConstraintsWithFormat(format: "V:[v0(2)]|", viewsArray: [bottomLine])
        selected(false)
    }
    
    func selected(_ value : Bool) {
        bottomLine.alpha = value == true ? 1 : 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

