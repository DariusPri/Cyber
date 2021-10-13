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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emailInputView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]-0@777-|", views: emailInputView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]-0@777-|", views: emailInputView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NoDataCollectionViewCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    let bg = NoTasksBackgroundView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)

        widthConstraint = NSLayoutConstraint(item: bg, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: bg, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
        
        bg.detailedView?.headerLabel.text = "No Data"
        bg.centerYConstraint?.constant = 0
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: bg)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: bg)
        
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
        
//        if let view = customView {
//            view.addSubview(errorView)
//            view.addConstraintsWithFormat(format: "V:|[v0]|", views: errorView)
//            NSLayoutConstraint(item: errorView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//            if let i = index {
//                mainStack.insertArrangedSubview(view, at: i)
//            } else {
//                mainStack.addArrangedSubview(view)
//            }
//        } else {
//            if let i = index {
//                mainStack.insertArrangedSubview(errorView, at: i)
//            } else {
//                mainStack.addArrangedSubview(errorView)
//            }
//        }
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
