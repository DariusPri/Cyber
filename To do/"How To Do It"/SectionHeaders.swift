//
//  SectionHeaders.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class ToDoSectionHeaderView: UICollectionReusableView {
    
    override func prepareForReuse() {
        titleLabel.text = nil
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 20)
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: titleLabel)
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(20, 20, 26))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ToDoSectionStepsHeaderView: UICollectionReusableView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.text = Localization.shared.steps.uppercased()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(12, 12, 16))
        
        let firstHorizontalLine = horizontalLine()
        let secondHorizontalLine = horizontalLine()
        let bottomVerticalLine = verticalLine()
        
        addSubview(firstHorizontalLine)
        addSubview(secondHorizontalLine)
        addSubview(bottomVerticalLine)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: firstHorizontalLine)
        addConstraintsWithFormat(format: "H:|[v0]|", views: secondHorizontalLine)
        addConstraintsWithFormat(format: "H:|-\(getCorrectSize(47, 47, 64))-[v0]", views: bottomVerticalLine)
        addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|[v0]-\(getCorrectSize(22, 22, 30))-[v1]-\(getCorrectSize(22, 22, 30))-[v2][v3(\(getCorrectSize(35, 35, 44)))]|", views: firstHorizontalLine, titleLabel, secondHorizontalLine, bottomVerticalLine)
    }
    
    func verticalLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 205/255, green: 222/255, blue: 236/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func horizontalLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 205/255, green: 222/255, blue: 236/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
