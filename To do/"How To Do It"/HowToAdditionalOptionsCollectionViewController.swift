//
//  HowToAdditionalOptionsCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 24/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class HowToAdditionalOptionsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var additionalOptionsData : [ToDoAdditionalOptionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.borderColor = UIColor(red: 225/255, green: 231/255, blue: 236/255, alpha: 1).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.isScrollEnabled = false 
        self.collectionView!.register(HoWToAdditionalOptionCell.self, forCellWithReuseIdentifier: "HoWToAdditionalOptionCell")
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return additionalOptionsData.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = additionalOptionsData[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HoWToAdditionalOptionCell", for: indexPath) as! HoWToAdditionalOptionCell
        cell.addBottomLine(isLast: additionalOptionsData.count - 1 == indexPath.item)
        cell.setupButton(isEnabled: data.statusEnabled)
        cell.titleLabel.text = data.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 75)
    }
    
}


class HoWToAdditionalOptionCell: UICollectionViewCell {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = #imageLiteral(resourceName: "test_logo")
        return imageView
    }()
    
    let statusButton = StatusButton()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 225/255, green: 231/255, blue: 236/255, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(statusButton)
        
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0(42)]-15@777-[v1]-10-|", views: iconImageView, titleLabel)
        containerView.addConstraintsWithFormat(format: "V:|-15-[v0(42)]", views: iconImageView)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15@777-[v1]", views: iconImageView, statusButton)
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]-15@777-|", views: statusButton)
        containerView.addConstraintsWithFormat(format: "V:|-15-[v0]", views: titleLabel)

        containerView.addSubview(lineView)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15@777-|", views: lineView)
        containerView.addConstraintsWithFormat(format: "V:[v0(1)]|", views: lineView)
    }
    
    func setupButton(isEnabled : Bool) {
        if isEnabled == true {
            statusButton.setTitle("  \(Localization.shared.enabled.uppercased())  ", for: .normal)
            statusButton.setTitleColor(UIColor(red: 114/255, green: 204/255, blue: 87/255, alpha: 1), for: .normal)
            statusButton.backgroundColor = UIColor(red: 114/255, green: 204/255, blue: 87/255, alpha: 0.2)
        } else {
            statusButton.setTitle("  \(Localization.shared.disabled.uppercased())  ", for: .normal)
            statusButton.setTitleColor(UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1), for: .normal)
            statusButton.backgroundColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 0.2)
        }
    }
    
    func addBottomLine(isLast : Bool) {
        lineView.alpha = isLast == true ? 0 : 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
