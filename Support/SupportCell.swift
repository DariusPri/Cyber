//
//  SupportCell.swift
//  Xpert
//
//  Created by Darius on 03/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SupportCell: UICollectionViewCell {
    
    var data : SupportCollectionViewController.SupportData? { didSet { updateUI() }}
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "listItemBackgroundColor")
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "defaultTextColor")
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    var subtitleLabel : IndicatorLabel = {
        let label = IndicatorLabel()
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let actionButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "supportActionButtonColor")
        button.imageView?.tintColor = UIColor(named: "supportActionButtonTintColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "arrow_right_blue"), for: .normal)
        button.imageView?.contentMode = .center
        button.layer.cornerRadius = 5
        button.isUserInteractionEnabled = false 
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(17, 17, 22))
        subtitleLabel.font = subtitleLabel.font.withSize(getCorrectSize(13, 13, 17))
        
        let infoStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 6
        
        containerView.addSubview(infoStack)
        containerView.addSubview(iconImageView)
        containerView.addSubview(actionButton)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(38, 38, 46)))]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(30, 30, 42)))]", views: actionButton)
        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(20, 20, 26))-[v0(\(getCorrectSize(38, 38, 46)))]-\(getCorrectSize(25, 25, 32))-[v1]-\(getCorrectSize(24, 24, 32))-[v2(\(getCorrectSize(30, 30, 42)))]-\(getCorrectSize(20, 20, 32))-|", views: iconImageView, infoStack, actionButton)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(17, 17, 22))-[v0]-\(getCorrectSize(20, 20, 26))-|", views: infoStack)
    }
    
    func updateUI() {
        guard let data = data else { return }
        iconImageView.image = data.icon
        titleLabel.text = data.title
        titleLabel.textColor = data.type == .hacked ? UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1) : UIColor(named: "defaultTextColor")
        subtitleLabel.text = data.subtitle
        titleLabel.sizeToFit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.size.width
        titleLabel.sizeToFit()
    }
    
    func resetIfNeeded() {
        if #available(iOS 13.0, *) {
            self.traitCollection.performAsCurrent {
                self.containerView.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
            }
        }
    }
       
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            resetIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
