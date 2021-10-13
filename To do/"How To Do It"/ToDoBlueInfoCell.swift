//
//  ToDoBlueInfoCell.swift
//  Xpert
//
//  Created by Darius on 28/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class ToDoBlueInfoCell : UICollectionViewCell {
    
    var data : ToDoBlueInfoData? { didSet{ updateUI() }}
    
    func updateUI() {
        guard let data = data else { return }
        titleLabel.text = data.title
        textLabel.text = data.text
        for (i, text) in data.checkListData.enumerated() { listStack.addArrangedSubview(createListLabel(text: text, index: i)) }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        listStack.arrangedSubviews.forEach { (list) in list.removeFromSuperview() }
    }
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 0.1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let viewMoreButton : UIButton = {
        let button = UIButton()
        button.setTitle(Localization.shared.view_more.uppercased(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        button.setTitleColor(UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), for: .normal)
        return button
    }()
    
    let listStack = UIStackView()
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        widthConstraint = NSLayoutConstraint(item: (contentView), attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        listStack.axis = .vertical
        listStack.spacing = 10
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)

        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(30, 30, 42))-[v0]-\(getCorrectSize(30, 30, 42))@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(textLabel)
        containerView.addSubview(listStack)
        containerView.addSubview(viewMoreButton)
        
        NSLayoutConstraint(item: viewMoreButton, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "H:[v0(126)]", views: viewMoreButton)
        containerView.addConstraintsWithFormat(format: "V:[v0(26)]-12-|", views: viewMoreButton)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 14))-[v0]-\(getCorrectSize(14, 14, 14))@777-|", views: titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 14))-[v0]-\(getCorrectSize(14, 14, 14))@777-|", views: textLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(14, 14, 14))-[v0]-\(getCorrectSize(14, 14, 14))@777-|", views: listStack)
        containerView.addConstraintsWithFormat(format: "V:|-12-[v0]-10-[v1]-20-[v2]", views: titleLabel, textLabel, listStack)

        bottomConstraint = NSLayoutConstraint(item: listStack, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: -12)
        bottomConstraint?.priority = .init(777)
        
        containerHeightConstraint = NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        containerHeightConstraint?.priority = .init(777)
        containerHeightConstraint?.isActive = true

        setGradientBackground(colorTop: UIColor(red: 229/255, green: 245/255, blue: 251/255, alpha: 0), colorBottom: UIColor(red: 229/255, green: 245/255, blue: 251/255, alpha: 1))
        
        containerView.bringSubviewToFront(viewMoreButton)
    }
    
    let gradientLayer = CAGradientLayer()
    
    var bottomConstraint : NSLayoutConstraint?
    var containerHeightConstraint : NSLayoutConstraint?
    

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    func setupCollapse(on : Bool) {
        if on == true {
            bottomConstraint?.isActive = false
            containerHeightConstraint?.constant = 200
            containerHeightConstraint?.isActive = true
            viewMoreButton.alpha = 1
        } else {
            containerHeightConstraint?.isActive = false
            bottomConstraint?.isActive = true
            viewMoreButton.alpha = 0
        }
        
        gradientLayer.isHidden = !on
        
        self.layoutIfNeeded()
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor){
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds
        containerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createListLabel(text: String, index: Int) -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        let mutableString = NSMutableAttributedString(string: "\(index+1))  \(text)")
        mutableString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Muli-Bold", size: 13)!, range: NSRange(location: 0, length: "\(index+1)".count+1))
        label.attributedText = mutableString
        return label
    }
}
