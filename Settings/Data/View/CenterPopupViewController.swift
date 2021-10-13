//
//  CenterPopupViewController.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class CenterPopupViewController: UIViewController {
    
    let animator = CustomPopupAnimation()
    
    let backgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.1)
        return view
    }()
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 26)
        label.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(red: 162/255, green: 174/255, blue: 183/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let closeButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.data_ok_got_it.uppercased(), image: nil, backgroundColor: UIColor.primaryButtonColor, textColor: UIColor.white)
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        return button
    }()

    init(icon : UIImage, title : String, subtitle : String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        iconImageView.image = icon
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupContent()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: backgroundView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: backgroundView)
               
        view.addSubview(contentView)
        view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=400)]-(>=15,==15@900)-|", views: contentView)
        NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupContent() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(closeButton)

        contentView.addConstraintsWithFormat(format: "H:[v0(95)]", views: iconImageView)
        contentView.addConstraintsWithFormat(format: "V:|-30-[v0(95)]-20-[v1]-25-[v2]-25-[v3(26)]-15-|", views: iconImageView, titleLabel, subtitleLabel, closeButton)
        NSLayoutConstraint(item: iconImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        contentView.addConstraintsWithFormat(format: "H:|-33-[v0]-33-|", views: titleLabel)
        contentView.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: subtitleLabel)
        contentView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: closeButton)

        closeButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
    }
    
    var closeCompletion : (()->())?

    @objc func closeViewController() {
        self.dismiss(animated: true, completion: closeCompletion)
    }

}
