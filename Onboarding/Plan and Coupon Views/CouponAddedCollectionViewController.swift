//
//  CouponAddedCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 14/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class CouponAddedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ErrorPresenter {
    
    var correctCollectionViewWidth : CGFloat = 300
    var couponAddedSummary :  [PaidPlan] = []
    var selectedPlan : PlanType? = nil {
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setupNav()
        
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView!.register(CouponAddedCell.self, forCellWithReuseIdentifier: "CouponAddedCell")
        self.collectionView!.register(InvertedCouponAddedCell.self, forCellWithReuseIdentifier: "InvertedCouponAddedCell")
        self.collectionView!.register(CouponAddedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CouponAddedHeaderView")
        (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView?.contentInset = .init(top: 20, left: 15, bottom: 100, right: 15)
        
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 740)) / 2
        correctCollectionViewWidth = view.bounds.size.width - horizontalInset * 2 - collectionView!.contentInset.left - collectionView!.contentInset.right
        
        
        getPlans { (error) in
            if let _ = error {
                self.presentSimpleOKError(withTitle: Localization.shared.can_t_get_plans, andSubtitle: "") {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.text = Localization.shared.upgrade_plane_standard_select_plan.capitalized
        titleLabel.textColor = UIColor(named: "couponNavTitleTextColor")
        return titleLabel
    }()
          
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "couponNavLeftButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        
        
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "couponNavRightButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.shared.device_done, style: .plain, target: self, action: #selector(doneSelectPlan))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: UIControl.State.highlighted)
        
        self.navigationItem.titleView = headerLabel
        self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
           
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
    }
       
       
    func resetIfNeeded() {
        if #available(iOS 13.0, *) {
            self.traitCollection.performAsCurrent {
                self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
                self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
                if traitCollection.userInterfaceStyle == .light {
                    self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                } else {
                    self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
                }
            }
        }
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            resetIfNeeded()
        }
    }
        
    
    
    func getPlans(completion: @escaping (Error?) -> ()) {
        
        guard let url = CyberExpertAPIEndpoint.plans.url() else { return completion(NetworkError.invalidURL) }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]) as [String : Any]??), let plans = json?["plans"] as? [[String : Any]] {
                for plan in plans {
                    let name = plan["name"] as? String ?? ""

                    var price : Double = 0.00
                    var uuid : String = ""
                    
                    if let planOptions = plan["options"] as? [[String : Any]] {
                        for option in planOptions {
                            if let model = option["model"] as? String, model == "payable" {
                                price = Double(option["net_price"] as? String ?? "0.0") ?? 0.0
                                uuid = option["uuid"] as? String ?? ""
                            }
                        }
                    }
                    
                    var planBenefits : [PlanBenefit] = []
                    
                    if let planFeatures = plan["plan_features"] as? [[String : Any]] {
                        for feature in planFeatures {
                            let title = feature["label"] as? String ?? ""
                            let highlight = feature["value"] as? String ?? ""
                            let status = PlanBenefitStatus.redFull
                            let benefit = PlanBenefit(title: title, highlightText: highlight, planBenefitStatus: status)
                            planBenefits.append(benefit)
                        }
                    }
                    
                    let planData = PaidPlan(type: PlanType(string: name), pricePerMonth: price, planBenefits: planBenefits, subtitle: "no text here..", priceWithCoupon: nil, priceWithDiscount: "1.99", uuid: uuid, isBoughtPlan: false)
                    self.couponAddedSummary.append(planData)
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
            
            completion(nil)
        }
        
    }
    
    @objc func closeViewController() {
        self.dismiss(animated: true, completion: {
            if let loginVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UINavigationController)?.viewControllers.first as? LoginViewController {
                loginVC.loginButton(isEnabled: true)
            }
        })
    }
    
    @objc func doneSelectPlan() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Header Stuff
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.alpha = 0
        cell.contentView.transform = CGAffineTransform.init(translationX: 0, y: 40)
        UIView.animate(withDuration: 0.3 + (Double(indexPath.item) * 0.1), delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            cell.contentView.alpha = 1
            cell.contentView.transform = CGAffineTransform.identity
        }) { (_) in }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CouponAddedHeaderView", for: indexPath) as! CouponAddedHeaderView
        headerView.closeCompletion = { self.closeViewController() }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: correctCollectionViewWidth, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return couponAddedSummary.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = couponAddedSummary[indexPath.item]
        
        if data.type == .trial {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InvertedCouponAddedCell", for: indexPath) as! InvertedCouponAddedCell
            cell.widthConstraint?.constant = correctCollectionViewWidth
            cell.couponAddedSummary = data
            cell.contentView.setNeedsLayout()
            cell.contentView.layoutIfNeeded()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponAddedCell", for: indexPath) as! CouponAddedCell
        cell.widthConstraint?.constant = correctCollectionViewWidth
        cell.couponAddedSummary = data
        cell.pricesView.oldPriceLabel.alpha = 1
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = couponAddedSummary[indexPath.item]
        
        if data.type == .trial {
            let welcomeTrialVC = ScanViewController(isTrial: true)
            self.navigationController?.pushViewController(welcomeTrialVC, animated: true)
            return
        }
        
        let paymentViewController = PaidPlansViewController()
        paymentViewController.planSelectedCompletion = {
            let welcomeVC = ScanViewController(isTrial: false)
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
        let nav = OpaqueNavigationBar(rootViewController: paymentViewController)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
}


class CouponAddedHeaderView: UICollectionReusableView, UITextViewDelegate {
    
    var closeCompletion : (()->())?
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 26)
        label.textColor = UIColor(named: "planViewHeaderTextColor")
        label.textAlignment = .center
        label.text = "Welcome to Dynarisk!"
        label.sizeToFit()
        return label
    }()
    
    let subheaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 17)
        label.textColor = UIColor(named: "planViewSubHeaderTextColor")
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(26, 26, 32))
        
        let mainStack = UIStackView(arrangedSubviews: [headerLabel, subheaderLabel])
        mainStack.spacing = 10
        mainStack.axis = .vertical
        mainStack.alignment = .center
        
        subheaderLabel.preferredMaxLayoutWidth = 450
        subheaderLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, Lorem ipsum dolor sit amet or start a Free Trial"
        let attr = NSMutableAttributedString(string: text)
        attr.addAttribute(.font, value: UIFont(name: "Muli-Regular", size: 17)!, range: NSRange(location: 0, length: text.count))
        attr.addAttribute(.foregroundColor, value: UIColor(named: "planViewSubHeaderTextColor")!, range: NSRange(location: 0, length: text.count))
        subheaderLabel.tintColor = .white
        subheaderLabel.attributedText = attr
        subheaderLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class InvertedCouponAddedCell: UICollectionViewCell {
    
    var couponAddedSummary : PaidPlan? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let data = couponAddedSummary else { return }
        headerLabel.text = data.type.rawValue
        subheaderLabel.text = data.subtitle
        pricesView.durationLabel.text = "3 months"
        pricesView.newPriceLabel.text = "FREE"
    }
    
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 46/255, green: 61/255, blue: 75/255, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    
    var pricesView : SinglePriceView = {
        let view = SinglePriceView(frame: .zero)
        view.durationLabel.textColor = UIColor(red: 162/255, green: 174/255, blue: 183/255, alpha: 1)
        view.newPriceLabel.textColor = UIColor(red: 162/255, green: 174/255, blue: 183/255, alpha: 1)
        return view
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 81/255, green: 105/255, blue: 127/255, alpha: 1)
        label.text = "All Professional features"
        return label
    }()
    
    let subheaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(red: 81/255, green: 105/255, blue: 127/255, alpha: 1)
        label.text = "[Text change]You need to complete all tasks for this device"
        label.numberOfLines = 0
        return label
    }()
    
    let couponAddedView = CouponAddedView(frame: .zero)
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(15, 15, 18))
        subheaderLabel.font = subheaderLabel.font.withSize(getCorrectSize(15, 15, 18))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        containerView.addSubview(pricesView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(subheaderLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(100)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: pricesView, headerLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(100)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: pricesView, subheaderLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(55)]", views: pricesView)
        NSLayoutConstraint(item: pricesView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(27, 27, 36))-[v0]-\(getCorrectSize(5, 5, 8))@777-[v1]-\(getCorrectSize(27, 27, 36))-|", views: headerLabel, subheaderLabel)
        
        containerView.layer.cornerRadius = getCorrectSize(5, 5, 8)
        
        addCouponAddedView()
    }
    
    func addCouponAddedView() {
        couponAddedView.titleLabel.text = "Trial Selected"
        couponAddedView.layoutIfNeeded()
        containerView.addSubview(couponAddedView)
        couponAddedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: couponAddedView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: couponAddedView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        couponAddedView.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool { didSet{ selectedCell() } }
    
    func selectedCell() {
        if isSelected == true {
            couponAddedView.alpha = 1
        } else {
            couponAddedView.alpha = 0
        }
    }
}

class SinglePriceView: UIView {
    
    let durationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 12)
        label.textColor = .gray
        label.text = "/ year"
        label.textAlignment = .right
        return label
    }()
    
    let newPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 28)
        label.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        label.text = "24.00"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(durationLabel)
        addSubview(newPriceLabel)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: durationLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: newPriceLabel)
        NSLayoutConstraint(item: newPriceLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        addConstraintsWithFormat(format: "V:[v0]-6-[v1]", views: newPriceLabel, durationLabel)
        
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





class CouponAddedCell: UICollectionViewCell {
    
    var couponAddedSummary : PaidPlan? { didSet{ updateUI() } }
    
    func updateUI() {
        guard let data = couponAddedSummary else { return }
        headerLabel.text = data.type.rawValue
        subheaderLabel.text = data.subtitle
        pricesView.setPrice(for: 111.11, and: 222.22)
        //pricesView.setPrice(for: data.pricePerMonth ?? ((data.pricePerYear ?? 0)/12).round(to:2) , and: Double(data.priceWithDiscount ?? String(data.pricePerMonth ?? data.pricePerYear)) ?? data.pricePerMonth ?? ((data.pricePerYear ?? 0) / 12).round(to: 2))
    }
    
    var containerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let pricesView = PriceView(frame: .zero)
    
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
    
    let couponAddedView = CouponAddedView(frame: .zero)
    let gl = CAGradientLayer()

    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(15, 15, 18))
        subheaderLabel.font = subheaderLabel.font.withSize(getCorrectSize(15, 15, 18))
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        containerView.addSubview(pricesView)
        containerView.addSubview(headerLabel)
        containerView.addSubview(subheaderLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(100)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: pricesView, headerLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 24))-[v0(100)]-\(getCorrectSize(20, 20, 32))@777-[v1]-10-|", views: pricesView, subheaderLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(80)]", views: pricesView)
        NSLayoutConstraint(item: pricesView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(27, 27, 36))-[v0]-\(getCorrectSize(5, 5, 8))@777-[v1]-\(getCorrectSize(27, 27, 36))-|", views: headerLabel, subheaderLabel)
        
        containerView.layer.cornerRadius = getCorrectSize(5, 5, 8)
        
        addGradient()
        addCouponAddedView()
    }
    
    func addGradient() {
        let colorTop = UIColor(red: 0 / 255.0, green: 163 / 255.0, blue: 218 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0 / 255.0, green: 91 / 255.0, blue: 239 / 255.0, alpha: 1.0).cgColor
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.0, 1.0]
        gl.startPoint = CGPoint(x: 0.0, y: 1.0)
        gl.endPoint = CGPoint(x: 1.0, y: 0.0)
        containerView.layer.insertSublayer(gl, at: 0)
        gl.frame = containerView.bounds
        gl.opacity = 0
        gl.cornerRadius = 5
    }
    
    func addCouponAddedView() {
        containerView.addSubview(couponAddedView)
        couponAddedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: couponAddedView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: couponAddedView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0).isActive = true
        couponAddedView.alpha = 0
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        gl.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool { didSet{ selectedCell() } }
    
    func selectedCell() {
        if isSelected == true {
            gl.opacity = 1
            pricesView.newPriceLabel.textColor = .white
            pricesView.oldPriceLabel.textColor = .white
            headerLabel.textColor = .white
            subheaderLabel.textColor = .white
            pricesView.poundSignLabel.textColor = .white
            pricesView.durationLabel.textColor = .white
            couponAddedView.alpha = 1
        } else {
            gl.opacity = 0
            pricesView.newPriceLabel.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
            pricesView.oldPriceLabel.textColor = .gray
            headerLabel.textColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
            subheaderLabel.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
            pricesView.poundSignLabel.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
            pricesView.durationLabel.textColor = UIColor(white: 0.8, alpha: 1)
            couponAddedView.alpha = 0
        }
    }
}

class CouponAddedView : UIView {
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Bold", size: 13)
        label.textColor = .white
        label.text = "Coupon Applied!"
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 32/255, green: 205/255, blue: 53/255, alpha: 1)
        layer.cornerRadius = 4
        
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20@777-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:|-7-[v0]-7@777-|", views: titleLabel)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PriceView: UIView {
    
    let oldPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 18)
        label.textColor = .gray
        label.text = "24.00"
        label.textAlignment = .right
        return label
    }()
    
    let newPriceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 28)
        label.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        label.text = "24.00"
        return label
    }()
    
    let poundSignLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 14)
        label.textColor = UIColor(red: 0, green: 163/255, blue: 218/255, alpha: 1)
        label.text = "£"
        label.sizeToFit()
        return label
    }()
    
    let durationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 11)
        label.textColor = UIColor(white: 0.8, alpha: 1)
        label.text = "/ yearly"
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(oldPriceLabel)
        addSubview(newPriceLabel)
        addSubview(durationLabel)
        addSubview(poundSignLabel)
        
        addConstraintsWithFormat(format: "H:[v0]|", views: oldPriceLabel)
        NSLayoutConstraint(item: durationLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newPriceLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: newPriceLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: poundSignLabel, attribute: .right, relatedBy: .equal, toItem: newPriceLabel, attribute: .left, multiplier: 1, constant: -2).isActive = true
        addConstraintsWithFormat(format: "V:|-(>=0)-[v0]-4-[v1]-0-[v2]-(>=0)-|", views: oldPriceLabel, newPriceLabel, durationLabel)
        
        addConstraintsWithFormat(format: "V:[v0(28)]", views: poundSignLabel)
        poundSignLabel.topAnchor.constraint(equalTo: newPriceLabel.topAnchor).isActive = true
        
    }
    
    func setPrice(for new : Double, and old : Double) {
        let attr = NSMutableAttributedString(string: "\(old)")
        attr.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attr.string.count))
        oldPriceLabel.attributedText = attr
        newPriceLabel.text = "\(new)"
        newPriceLabel.sizeToFit()
        oldPriceLabel.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

