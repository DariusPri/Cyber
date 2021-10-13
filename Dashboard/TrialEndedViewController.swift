//
//  TrialEndedViewController.swift
//  Xpert
//
//  Created by Darius on 13/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class TrialEndedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override var preferredStatusBarStyle : UIStatusBarStyle { return .lightContent }
    var correctCollectionViewWidth : CGFloat = 300
    
    struct TrialData {
        var title : String
        var subtitle : String
        var image : UIImage
    }
    
    var trialEndedSummary : [TrialData] = [TrialData(title: "300 Unfinished tasks", subtitle: "You have 3 inactive devices in your account", image: #imageLiteral(resourceName: "trial_1_logo")),
                                           TrialData(title: "3 Deactivated devices", subtitle: "You have 3 inactive devices in your account", image: #imageLiteral(resourceName: "trial_2_logo")),
                                           TrialData(title: "2 Unprotected emails", subtitle: "You have 3 inactive devices in your account", image: #imageLiteral(resourceName: "trial_3_logo"))]
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView!.register(TrialEndedCell.self, forCellWithReuseIdentifier: "TrialEndedCell")
        self.collectionView!.register(TrialEndedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrialEndedHeaderView")
        (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView?.contentInset = .init(top: 20, left: 15, bottom: 100, right: 15)
        
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 740)) / 2
        correctCollectionViewWidth = view.bounds.size.width - horizontalInset * 2 - collectionView!.contentInset.left - collectionView!.contentInset.right
        
        addPlanButton()
        setupNav()
    }
    
    func addPlanButton() {
        let planButton = PlanButton(title: Localization.shared.upgrade_plan.uppercased(), image: nil, backgroundColor: UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1), textColor: .white)
        planButton.titleLabel?.font = planButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 21))
        planButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 70)).isActive = true
        planButton.translatesAutoresizingMaskIntoConstraints = false
        planButton.addTarget(self, action: #selector(changePlanAction), for: .touchUpInside)
        
        view.addSubview(planButton)
        
        let guide = self.view.safeAreaLayoutGuide
        planButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: planButton)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: planButton)
        }
        NSLayoutConstraint(item: planButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func changePlanAction() {
        let paymentViewController = PaidPlansViewController() // fix this..
        paymentViewController.planSelectedCompletion = {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        let nav = OpaqueNavigationBar(rootViewController: paymentViewController)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = .white
        titleLabel.text = "Trial Expired"
        
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    }
    
    @objc func closeViewController() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Header Stuff
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrialEndedHeaderView", for: indexPath) as! TrialEndedHeaderView
        //headerView.headerLabel.sizeToFit()
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //return CGSize(width: collectionView.bounds.size.width, height: section == 0 ? .leastNonzeroMagnitude : collectionView.getCorrectSize(60, 60, 74))
        return CGSize(width: correctCollectionViewWidth, height: 312)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero // section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return trialEndedSummary.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrialEndedCell", for: indexPath) as! TrialEndedCell
        //cell.data = paidPlanData.planBenefits[indexPath.item]
        //cell.leftConstraint?.constant = collectionView.getCorrectSize(0, (UIScreen.main.bounds.size.width - 520) / 2, (UIScreen.main.bounds.size.width - 530) / 2 )
        //cell.contentView.setNeedsLayout()
        //cell.contentView.layoutIfNeeded()
        cell.widthConstraint?.constant = correctCollectionViewWidth
        cell.trialData = trialEndedSummary[indexPath.item]
        return cell
    }
    
}


class TrialEndedHeaderView: UICollectionReusableView {
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Your trial has expired!"
        label.sizeToFit()
        return label
    }()
    
    let subheaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(red: 162/255, green: 174/255, blue: 183/255, alpha: 1)
        label.textAlignment = .center
        label.text = "Upgrade plan to re activate unprotected devices"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "trial_ended_logo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(26, 26, 32))
        subheaderLabel.font = subheaderLabel.font.withSize(getCorrectSize(17, 17, 20))
       
        addSubview(headerLabel)
        addSubview(subheaderLabel)
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: headerLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: subheaderLabel)
        addConstraintsWithFormat(format: "H:[v0(147)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(147)]", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]-30-[v1]-25-[v2]-(>=0)-|", views: imageView, headerLabel, subheaderLabel)
        
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TrialEndedCell: UICollectionViewCell {
    
    var trialData : TrialEndedCollectionViewController.TrialData? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let data = trialData else { return }
        headerLabel.text = data.title
        subheaderLabel.text = data.subtitle
        iconImageView.image = data.image
    }
    
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
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
        
        //NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width).isActive = true
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)

        //NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
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
