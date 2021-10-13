//
//  VIPPlanCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 24/10/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class VIPPlanCollectionViewController : PaidPlansCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundView()
        
        self.collectionView?.register(VIPDetailsCell.self, forCellWithReuseIdentifier: "VIPDetailsCell")
        self.collectionView?.register(VIPDetailsBenefitCell.self, forCellWithReuseIdentifier: "VIPDetailsBenefitCell")
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
        
        self.collectionView.backgroundColor = .bgColorDark
    }
    
    
    // MARK: Custom Navigation Bar Styling
    
    override func initialNavStyle() {
        nav.shadowImage = nil
        nav.isTranslucent = true
        nav.setBackgroundImage(#imageLiteral(resourceName: "vip_nav_bg").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
        
        headerLabel.textColor = .white
        
        if let standaloneItem = self.nav.items?.first {
            let leftButtonAttributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor : UIColor.white,
                NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
            ]
            standaloneItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: .normal)
            standaloneItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: .highlighted)
        }
    }
        
    override func resetIfNeeded() {}
  
    // MARK: VIP Background View
    
    var bgView : UIImageView?
    
    func addBackgroundView() {
        bgView = UIImageView(image: #imageLiteral(resourceName: "vip_bg"))
        bgView?.contentMode = .scaleAspectFill
        self.collectionView?.backgroundView = bgView
    }
    
    // MARK: CollectionView Data Source
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offsetY = self.collectionView!.convert(self.collectionView!.frame.origin, to: self.view).y * (-1)
        bgView?.frame = CGRect(x: 0, y: offsetY, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 { return CGFloat.leastNonzeroMagnitude }
        else if section == 1 { return view.getCorrectSize(10, 10, 20) }
        else { return 30 }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 { return .zero }
        else if section == 1 { return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) }
        else { return UIEdgeInsets.init(top: 30, left: 0, bottom: 50, right: 0) }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlanHeaderView", for: indexPath) as! PlanHeaderView
        headerView.subviews.forEach({view in view.alpha = 0 })
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: .leastNonzeroMagnitude)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 3 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        else if section == 1 { return 3 }
        else { return paidPlanData.planBenefits.count }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VIPDetailsCell", for: indexPath) as! VIPDetailsCell
            cell.numberOfItems = numberOfPlans
            cell.data = paidPlanData
            cell.planIndicatorView.setSelectedAt(index: indicatorIndex)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VIPDetailsBenefitCell", for: indexPath) as! VIPDetailsBenefitCell
            cell.widthConstraint?.constant = collectionView.isHugeScreenSize == true ? 700 : min(500, collectionView.bounds.size.width-30)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanBenefitCell", for: indexPath) as! PlanBenefitCell
            cell.data = paidPlanData.planBenefits[indexPath.item]
            cell.benefitLabel.textColor = .white
            cell.leftConstraint?.constant = collectionView.getCorrectSize(0, (UIScreen.main.bounds.size.width - 520) / 2, (UIScreen.main.bounds.size.width - 530) / 2 )
            return cell
        }
    }
}


class VIPDetailsCell : PlanDetailsCell {
    override func updateUI() {
        guard let data = data else { return }
        priceLabel.text = "\(data.pricePerMonth ?? ((data.pricePerYear ?? 0) / 12).round(to: 2))"
        priceLabel.numberOfLines = 0 
        priceLabel.sizeToFit()
        planIndicatorView.numberOfItems = numberOfItems
        planIndicatorView.setupItems()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        planButton.backgroundColor = .white
        planButton.setTitleColor(UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1), for: .normal)
        planButton.setTitle(Localization.shared.vip.uppercased(), for: .normal) ;
        priceLabel.textColor = .white
        poundSignLabel.textColor = .white
        periodLabel.textColor = .white
        
        planIndicatorView.setViewForVIP()
        planIndicatorView.setSelectedAt(index: 3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VIPDetailsBenefitCell : UICollectionViewCell {
    
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "secscan_ill_light")
        return imageView
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        label.text = "All Professional features"
        return label
    }()
    
    let subheaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.text = "[Text change]You need to complete all tasks for this device"
        label.numberOfLines = 0 
        return label
    }()
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(15, 15, 18))
        subheaderLabel.font = subheaderLabel.font.withSize(getCorrectSize(15, 15, 18))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width).isActive = true
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        widthConstraint = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.isActive = true
        
        containerView.addSubview(iconImageView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(subheaderLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(55)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: iconImageView, headerLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(55)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: iconImageView, subheaderLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(55)]", views: iconImageView)
        NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(27, 27, 36))-[v0]-\(getCorrectSize(5, 5, 8))-[v1]-\(getCorrectSize(27, 27, 36))-|", views: headerLabel, subheaderLabel)

        containerView.layer.cornerRadius = getCorrectSize(5, 5, 8)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
