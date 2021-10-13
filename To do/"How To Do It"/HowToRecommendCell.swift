//
//  HowToRecommendCell.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class HowToRecommendCell: UICollectionViewCell {
    
    let containerView = UIView()
    
    var howToRecommendCVController : HowToRecommendCollectionViewController?
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        heightConstraint?.priority = .init(rawValue: 777)
        heightConstraint?.isActive = true
        
        contentView.addSubview(containerView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
    }
    
    func setupCV() {
        guard let cv = howToRecommendCVController else { return }
        containerView.addSubview(cv.view)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]|", views: cv.view)
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: cv.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





