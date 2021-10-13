//
//  HowToRecommendCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 20/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class HowToRecommendCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var recomendationData : [ToDoRecomendationData]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(HowToRecommendationCell.self, forCellWithReuseIdentifier: "HowToRecommendationCell")
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal
        self.collectionView?.contentInset = .init(top: 0, left: 0, bottom: 10, right: 30)
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.contentInsetAdjustmentBehavior = .never
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return (recomendationData?.count ?? 0) }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HowToRecommendationCell", for: indexPath) as! HowToRecommendationCell
        cell.data = recomendationData?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 276, height: (collectionView.bounds.height) - 10)
    }
}


class HowToRecommendationCell: UICollectionViewCell {
    
    var data : ToDoRecomendationData? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let data = data else { return }
        titleLabel.text = data.name
        priceLabel.text = data.price == Float(0) ? Localization.shared.free.uppercased() : "\(data.price) £"
    }
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "kaspersky_logo")
        return imageView
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor(red: 225/255, green: 231/255, blue: 236/255, alpha: 1).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
    
    let actionButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "externallin_ic"), for: .normal)
        button.setTitle(Localization.shared.to_visit_website.uppercased(), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 0.1)
        button.layer.cornerRadius = 3
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        button.imageEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(actionButton)
        
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0(42)]-15-[v1]-10-|", views: iconImageView, titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0(42)]-15-[v1]-10-|", views: iconImageView, priceLabel)
        containerView.addConstraintsWithFormat(format: "V:|-15-[v0(42)]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-[v1]-14-|", views: iconImageView, actionButton)
        containerView.addConstraintsWithFormat(format: "V:|-15-[v0]-6-[v1]", views: titleLabel, priceLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(26)]-15-|", views: actionButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
