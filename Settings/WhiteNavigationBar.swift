//
//  WhiteNavigationBar.swift
//  Xpert
//
//  Created by Darius on 2020-01-15.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class WhiteNavigationBar: UINavigationBar {
    
    struct BarButtonData {
        var title : String
        var color : UIColor
        var target : Any?
        var selector : Selector?
    }
    
    let headerLabel : UILabel = {
         let titleLabel = UILabel()
         titleLabel.text = Localization.shared.personal_information
         titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
         titleLabel.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
         return titleLabel
     }()
    
    init(header : String, leftButtonData : BarButtonData?, rightButtonData : BarButtonData?) {
        headerLabel.text = header
        super.init(frame: .zero)
        setupBarButton(withLeftData: leftButtonData, andRightData: rightButtonData)
        setupNavBar()
    }
    
    func setupBarButton(withLeftData leftData : BarButtonData?, andRightData rightData : BarButtonData?) {
        
        func createBarButtonItem(data : BarButtonData?) -> UIBarButtonItem? {
            if let data = data {
                let leftButtonAttributes : [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.foregroundColor : data.color,
                    NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
                ]
                let backButton = UIBarButtonItem(title: data.title, style: .plain, target: data.target, action: data.selector)
                backButton.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
                backButton.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
                return backButton
            } else {
                return nil
            }
        }
        
        let leftBarItem = createBarButtonItem(data: leftData)
        let rightBarItem = createBarButtonItem(data: rightData)
        
        standaloneItem.leftBarButtonItem = leftBarItem
        standaloneItem.rightBarButtonItem = rightBarItem
    }
    
    let standaloneItem = UINavigationItem()

    func setupNavBar() {
        standaloneItem.titleView = headerLabel
        isTranslucent = false
        delegate = self
        backgroundColor = .white
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        items = [standaloneItem]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WhiteNavigationBar : UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
