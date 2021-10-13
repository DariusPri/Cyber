//
//  NoTasksBackgroundView.swift
//  Xpert
//
//  Created by Darius on 26/11/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class NoTasksBackgroundView: UIView {
    
    var detailedView : DetailedView?
    var centerYConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        detailedView = DetailedView(image: #imageLiteral(resourceName: "donecheck_ill_dark"), header: Localization.shared.everything_ok, subheader: Localization.shared.to_you_have_no_tasks_in_your_to_do_list_check_once_in)
        detailedView!.headerLabel.heightAnchor.constraint(equalToConstant: 39).isActive = true
        detailedView!.headerLabel.font = UIFont(name: "Muli-Regular", size: getCorrectSize(26, 26, 34))
        detailedView!.subheaderLabel.font = UIFont(name: "Muli-Regular", size: getCorrectSize(17, 17, 22))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = 1.1
        paragraphStyle.alignment = detailedView!.subheaderLabel.textAlignment
        
        let attrString = NSMutableAttributedString(string: detailedView!.subheaderLabel.text!)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange.init(location: 0, length: detailedView!.subheaderLabel.text!.count))
        detailedView!.subheaderLabel.attributedText = attrString
        
        detailedView!.mainStack.setCustomSpacing(getCorrectSize(58, 58, 78), after: detailedView!.mainImageView)
        detailedView!.mainStack.setCustomSpacing(getCorrectSize(25, 25, 34), after: detailedView!.headerLabel)
        detailedView!.mainImageViewWidthContraint.constant = getCorrectSize(126, 126, 160)
        detailedView!.mainImageViewHeightConstraint.constant = getCorrectSize(126, 126, 160)
        
        addSubview(detailedView!)
        if isSmallScreenSize == true {
            addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: detailedView!)
        } else {
            addConstraintsWithFormat(format: "H:[v0(\(min(calculatedNewScreenWidth, 520)))]", views: detailedView!)
        }
        
        centerYConstraint = NSLayoutConstraint(item: detailedView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: getCorrectSize(-68, -68, -140))
        centerYConstraint?.isActive = true
        NSLayoutConstraint(item: detailedView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
