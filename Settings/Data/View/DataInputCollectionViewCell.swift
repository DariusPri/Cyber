//
//  DataInputCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 2019-07-03.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class DataInputCollectionViewCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    let emailInputView = EmailInputView()
    let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        widthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        containerView.addSubview(emailInputView)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: emailInputView)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: emailInputView)

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ErrorCollectionViewCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    let containerView = UIView()
    
    var errorViewModel : ErrorViewModel? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard let errorTitleArray = errorViewModel?.errorText else { return }
        let errorView = ErrorView(errorTitleArray: errorTitleArray)
        containerView.subviews.forEach { (a) in a.removeFromSuperview() }
        containerView.addSubview(errorView)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: errorView)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: errorView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
