//
//  DetailedView.swift
//  Xpert
//
//  Created by Darius on 2020-02-05.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DetailedView: UIView {
    
    let mainImageViewWidthContraint : NSLayoutConstraint
    let mainImageViewHeightConstraint : NSLayoutConstraint

    let mainImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 26)
        label.textColor = UIColor(named: "defaultTextColor")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let subheaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(red: 162/255, green: 174/255, blue: 183/255, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let mainStack : UIStackView

    init(image : UIImage, header : String, subheader : String) {

        mainImageViewHeightConstraint = mainImageView.heightAnchor.constraint(equalToConstant: 90)
        mainImageViewHeightConstraint.priority = .init(777)
        mainImageViewWidthContraint = mainImageView.widthAnchor.constraint(equalToConstant: 100)
        mainImageViewWidthContraint.priority = .init(777)

        mainStack = UIStackView(arrangedSubviews: [mainImageView, headerLabel, subheaderLabel])
        super.init(frame: .zero)
        
        mainImageViewWidthContraint.constant = getCorrectSize(100, 100, 130)
        mainImageViewHeightConstraint.constant = getCorrectSize(90, 90, 120)
        mainImageViewHeightConstraint.isActive = true
        mainImageViewWidthContraint.isActive = true
        
        mainImageView.image = image
        headerLabel.text = header
        subheaderLabel.text = subheader
        
        mainStack.spacing = getCorrectSize(25, 25, 32)
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.setCustomSpacing(getCorrectSize(58, 58, 76), after: mainImageView)
        
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainStack)

        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
