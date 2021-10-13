//
//  HowToAdditionalOptionsSearchCell.swift
//  Xpert
//
//  Created by Darius on 26/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class HowToAdditionalOptionsSearchCell: UICollectionViewCell {
    
    var widthConstraint : NSLayoutConstraint?
    let containerView = UIView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.text = Localization.shared.search_apps
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        return label
    }()
    
    let searchTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Muli-Regular", size: 15)
        textField.placeholder = Localization.shared.to_search_apps+"..."
        textField.backgroundColor = .white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 0.2).cgColor
        textField.layer.cornerRadius = 3
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 30))
        textField.leftView = view
        textField.leftViewMode = .always
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        contentView.addSubview(containerView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(searchTextField)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-(>=10)-|", views: titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: searchTextField)
        containerView.addConstraintsWithFormat(format: "V:|[v0]-(16@777)-[v1(50)]|", views: titleLabel, searchTextField)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class HowToAdditionalOptionsCell: UICollectionViewCell {
    
    let containerView = UIView()
    
    var howToAdditionalOptionsCVController : HowToAdditionalOptionsCollectionViewController?
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
        heightConstraint?.priority = .init(rawValue: 777)
        heightConstraint?.isActive = true
        
        contentView.addSubview(containerView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
    }
    
    func setupCV() {
        guard let cv = howToAdditionalOptionsCVController else { return }
        containerView.addSubview(cv.view)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: cv.view)
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: cv.view)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        howToAdditionalOptionsCVController?.collectionViewLayout.invalidateLayout()
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.frame.size.height = (howToAdditionalOptionsCVController?.collectionView?.contentSize.height ?? 75)
        if let contentHeight = howToAdditionalOptionsCVController?.collectionView?.contentSize.height, contentHeight > 1 {
            heightConstraint?.constant = CGFloat(contentHeight)
        }
        return attributes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
