//
//  EmailCollectionViewCell.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class EmailCollectionViewCell: UICollectionViewCell {
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    let emailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(named: "dataCellTitleColor")
        return label
    }()
    let statusLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.textColor = UIColor(named: "dataCellStatusColor")
        return label
    }()
    
    let infoButton : UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let resendActivationLinkButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.resend_activation_link.uppercased(), image: nil, backgroundColor: UIColor(named: "dataActivationButtonColor")!, textColor: UIColor(named: "dataActivationButtonTextColor")!)
        button.titleLabel?.font = UIFont(name: "Muli-Bold", size: 10)
        button.sizeToFit()
        return button
    }()
    
    func updateUI(with text : String, isActive : Bool, isFamilyMember: Bool, infoButtonVisible : Bool, activationButtonIsActive : Bool) {
        infoButton.isHidden = !infoButtonVisible
        emailLabel.text = text
        resendActivationLinkButton.isEnabled = activationButtonIsActive
        if isActive == true {
            iconImageView.image = isHugeScreenSize == true ? #imageLiteral(resourceName: "check_ultrasmall_huge") : #imageLiteral(resourceName: "check_ultrasmall")
            iconImageView.backgroundColor = UIColor(red: 32/255, green: 205/255, blue: 53/255, alpha: 1)
            
            if isFamilyMember == true {
                statusLabel.text = Localization.shared.active.capitalized+" - "+Localization.shared.data_family_member_s_email_
            } else {
                statusLabel.text = Localization.shared.active
            }
            
            resendButtonBottomConstraint?.isActive = false
            statusLabelBottomConstraint?.isActive = true
            resendActivationLinkButton.alpha = 0
        } else {
            iconImageView.image = nil
            iconImageView.backgroundColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
            
            if isFamilyMember == true {
                statusLabel.text = Localization.shared.pending.capitalized+" - "+Localization.shared.data_family_member_s_email_
            } else {
                statusLabel.text = Localization.shared.pending.capitalized
            }
            
            statusLabelBottomConstraint?.isActive = false
            resendButtonBottomConstraint?.isActive = true
            resendActivationLinkButton.alpha = 1
        }
            
        emailLabel.sizeToFit()
        statusLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    var widthConstraint : NSLayoutConstraint?
    let containerView = UIView()
    var resendButtonBottomConstraint: NSLayoutConstraint?
    var statusLabelBottomConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        widthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(emailLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(infoButton)
        containerView.addSubview(iconImageView)
        containerView.addSubview(resendActivationLinkButton)
        
        emailLabel.font = emailLabel.font.withSize(getCorrectSize(17, 17, 21))
        statusLabel.font = statusLabel.font.withSize(getCorrectSize(13, 13, 16))
        iconImageView.layer.cornerRadius = getCorrectSize(6, 6, 8)
        resendActivationLinkButton.titleLabel?.font = resendActivationLinkButton.titleLabel?.font.withSize(getCorrectSize(10, 10, 14))
        infoButton.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "more_active_ic_huge") : #imageLiteral(resourceName: "more_active_ic") , for: .normal)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(12, 12, 16)+7+25)-[v0]-12@777-|", views: resendActivationLinkButton)
        containerView.addConstraintsWithFormat(format: "V:[v0]-19@777-[v1(\(getCorrectSize(26, 26, 38))@777)]", views: statusLabel, resendActivationLinkButton)
        
        resendButtonBottomConstraint = NSLayoutConstraint(item: resendActivationLinkButton, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        resendButtonBottomConstraint?.isActive = true
        
        statusLabelBottomConstraint = NSLayoutConstraint(item: statusLabel, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        statusLabelBottomConstraint?.isActive = true
        
        containerView.addConstraintsWithFormat(format: "H:|-7-[v0(\(getCorrectSize(12, 12, 16)))]-25@777-[v1]-10-[v2(\(getCorrectSize(24, 24, 28)))]-15-|", views: iconImageView, emailLabel, infoButton)
        containerView.addConstraintsWithFormat(format: "H:[v0]-25@777-[v1]-10-[v2(\(getCorrectSize(24, 24, 28)))]", views: iconImageView, emailLabel, infoButton)
        containerView.addConstraintsWithFormat(format: "V:[v0(\(getCorrectSize(12, 12, 16)))]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "V:|-25-[v0(24)]", views: infoButton)
        containerView.addConstraintsWithFormat(format: "V:|-25-[v0(21)]-\(getCorrectSize(5, 5, 9))@777-[v1]", views: emailLabel, statusLabel)
        NSLayoutConstraint(item: statusLabel, attribute: .left, relatedBy: .equal, toItem: emailLabel, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: iconImageView, attribute: .top, relatedBy: .equal, toItem: emailLabel, attribute: .top, multiplier: 1, constant: 6).isActive = true
               
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




