//
//  HowToRawDataExposedCell.swift
//  Xpert
//
//  Created by Darius on 08/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class HowToRawDataExposedCell: UICollectionViewCell {
    
    var rawData : RawDataExposedData? { didSet{ updateUI() }}
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?

    let exposedDataView = ExposedDataView()
    let exposedHeaderView = ExposedDataHeaderView()
    
    func updateUI() {
        exposedDataView.infoLabel.text = rawData?.dataString ?? ""
        text = rawData?.dataString ?? ""
        exposedDataView.infoLabel.sizeToFit()
        setNeedsLayout()
        layoutIfNeeded()
        
        if exposedDataView.bounds.size.height > exposedHeaderView.bounds.size.height {
            heightConstraint?.constant = exposedDataView.bounds.size.height + 10
            exposedHeaderView.heightConstraint?.constant = exposedDataView.bounds.size.height
        } else {
            heightConstraint?.constant = exposedHeaderView.bounds.size.height + 10
        }
        
        bottomConstraint?.isActive = true
        bottomConstraint2?.isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bottomConstraint?.isActive = false
        bottomConstraint2?.isActive = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        heightConstraint?.priority = .init(rawValue: 777)
        heightConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(exposedDataView)
        contentView.addConstraintsWithFormat(format: "H:|-30-[v0]-30@777-|", views: exposedDataView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]", views: exposedDataView)
        
        contentView.addSubview(exposedHeaderView)
        contentView.addConstraintsWithFormat(format: "H:|-30-[v0]-30@777-|", views: exposedHeaderView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]", views: exposedHeaderView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(exposeRawData))
        exposedHeaderView.isUserInteractionEnabled = true
        exposedHeaderView.addGestureRecognizer(tap)
        
        bottomConstraint = NSLayoutConstraint(item: exposedDataView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -10)
        bottomConstraint2 = NSLayoutConstraint(item: exposedHeaderView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -10)
    }
    
    var bottomConstraint : NSLayoutConstraint?
    var bottomConstraint2 : NSLayoutConstraint?
    
    var text : String = ""
    
    @objc func exposeRawData() {
        exposedHeaderView.alpha = 0
        exposedDataView.infoLabel.setTextWithTypeAnimation(typedText: text,  completion: {
            self.exposedDataView.infoLabel.animateLastBlinkingDash(delay: 1)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ExposedDataHeaderView: UIView {
    
    var infoHeaderLabel : UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.text = Localization.shared.to_tap_here_to_see_your_raw_breached_data
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Courier", size: 18)
        label.sizeToFit()
        return label
    }()
    
    var infoLabel : UILabel = {
        let label = UILabel()
        label.text = Localization.shared.to_make_sure_you_are_in_a_private_place_the_data_you_
        label.textColor = .green
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Courier", size: 14)
        label.sizeToFit()
        return label
    }()
    
    var heightConstraint : NSLayoutConstraint?
    let container = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        container.addSubview(infoHeaderLabel)
        container.addSubview(infoLabel)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: infoLabel)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: infoHeaderLabel)
        container.addConstraintsWithFormat(format: "V:|[v0]-12-[v1]|", views: infoHeaderLabel, infoLabel)
        
        addSubview(container)
        
        addConstraintsWithFormat(format: "H:|-30-[v0]-30@777-|", views: container)
        NSLayoutConstraint(item: container, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = heightAnchor.constraint(equalToConstant: 100)
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightConstraint?.constant = self.bounds.size.height - container.bounds.size.height < 60 ? container.bounds.size.height + 60 : self.bounds.size.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ExposedDataView: UIView {
    
    var infoLabel : UILabel = {
        let label = UILabel()
        label.textColor = .green
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont(name: "Courier", size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(infoLabel)
        addConstraintsWithFormat(format: "H:|-30-[v0]-30@777-|", views: infoLabel)
        addConstraintsWithFormat(format: "V:|-30-[v0]-30@777-|", views: infoLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
