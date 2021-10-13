//
//  SecurityScoreCell.swift
//  Xpert
//
//  Created by Darius on 15/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class SecurityScoreCell: SettingsCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLoader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scoreLabel : AnimatedLabel = {
        let label = AnimatedLabel()
        label.font = UIFont(name: "Muli-Regular", size: 36)
        label.text = "0"
        label.textColor = UIColor(named: "defaultTextColor")
        return label
    }()
    
    private let totalScoreLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 14)
        label.text = "/999"
        label.textColor = UIColor(named: "defaultTextColor")
        label.alpha = 0.7
        return label
    }()
    
    let explainerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.text = Localization.shared.your_cyber_security_score
        label.textAlignment = .center
        label.textColor = UIColor(named: "defaultTextColor")
        return label
    }()
    
    var loader : CircleLoaderView?
    
    func addLoader() {
        
        scoreLabel.font = scoreLabel.font.withSize(getCorrectSize(36, 36, 44))
        totalScoreLabel.font = totalScoreLabel.font.withSize(getCorrectSize(14, 14, 16))
        explainerLabel.font = explainerLabel.font.withSize(getCorrectSize(17, 17, 22))
        
        backgroundColor = .clear
        
        loader = CircleLoaderView(frame: .zero)
        loader!.backgroundColor = .clear
        contentView.addSubview(loader!)
        loader!.widthAnchor.constraint(equalToConstant: getCorrectSize(212, 212, 260)).isActive = true
        loader!.heightAnchor.constraint(equalToConstant: getCorrectSize(212, 212, 260)).isActive = true
        loader!.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraintsWithFormat(format: "V:|-10-[v0(\(getCorrectSize(212, 212, 260)))]", views: loader!)
        NSLayoutConstraint(item: loader!, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        loader!.setNeedsLayout()
        loader!.layoutIfNeeded()
        
        
        contentView.addSubview(scoreLabel)
        NSLayoutConstraint(item: scoreLabel, attribute: .centerY, relatedBy: .equal, toItem: loader!, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: scoreLabel, attribute: .centerX, relatedBy: .equal, toItem: loader!, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        contentView.addSubview(totalScoreLabel)
        contentView.addConstraintsWithFormat(format: "V:[v0]-4-[v1]", views: scoreLabel, totalScoreLabel)
        NSLayoutConstraint(item: totalScoreLabel, attribute: .centerX, relatedBy: .equal, toItem: loader!, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        contentView.addSubview(explainerLabel)
        contentView.addConstraintsWithFormat(format: "V:[v0]-\(getCorrectSize(4, 4, 8))-[v1]", views: loader!, explainerLabel)
        NSLayoutConstraint(item: explainerLabel, attribute: .centerX, relatedBy: .equal, toItem: loader!, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
  
    }
}
