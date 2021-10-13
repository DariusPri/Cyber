//
//  NotificationCell.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class NotificationCell: SettingsCell {
    
    var cv : NotificationCollectionViewController?
    
    func setupNotificationCV(with cv : NotificationCollectionViewController) {
        
        if self.cv != nil { return }
        
        self.cv = cv
        contentView.subviews.forEach { (sub) in
            sub.removeFromSuperview()
        }
        contentView.addSubview(cv.view)
        addConstraintsWithFormat(format: "H:|[v0]|", views: cv.view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: cv.view)
        cv.collectionView.collectionViewLayout.invalidateLayout()
        self.layoutIfNeeded()
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        UIView.animate(withDuration: 0.6) {
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NotificationView: UIView {
    
    let titleLabel = UILabel()
    let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let smallActionButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(smallActionButton)
        
        iconImageView.backgroundColor = .gray
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        smallActionButton.backgroundColor = .blue
        
        addConstraintsWithFormat(format: "H:|-20-[v0(50)]-30-[v1]-10-[v2(50)]-20-|", views: iconImageView, titleLabel, smallActionButton)
        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: smallActionButton, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: iconImageView)
        addConstraintsWithFormat(format: "V:[v0(50)]", views: smallActionButton)
        
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


