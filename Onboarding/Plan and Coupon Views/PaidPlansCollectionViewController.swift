//
//  PaidPlansCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 23/10/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SafariServices

enum PlanType : String {
    case notSelected = "N/A"
    case trial = "Trial Plan"
    case vip = "VIP Plan"
    case essential = "Essential Plan"
    case standard = "Standard Plan"
    case professional = "Professional"
    case advantage = "Advantage Plan"
    case ultimate = "Ultimate Plan"
    
    init(string : String) {
        switch string.lowercased() {
        case "standard":
            self = .standard
        case "trial":
            self = .trial
        case "essential":
            self = .essential
        case "professional":
            self = .professional
        case "vip":
            self = .vip
        case "advantage":
            self = .advantage
        case "ultimate":
            self = .ultimate
        default:
            self = .notSelected
        }
    }
    
    func stringForIdentifier() -> String {
        switch self {
        case .standard:
            return "standard"
        case .trial:
            return "trial"
        case .essential:
            return "essential"
        case .professional:
            return "professional"
        case .vip:
            return "vip"
        case .advantage:
            return "advantage"
        case .ultimate:
            return "ultimate"
        default:
            return ""
        }
    }
    
}

struct PaidPlan {
    var type: PlanType
    var pricePerMonth : Double?
    var pricePerYear : Double?
    var planBenefits : [PlanBenefit]
    var subtitle : String
    var priceWithCoupon : String?
    var priceWithDiscount : String?
    var uuid : String
    var isAppStorePlan : Bool?
    var appStoreIdentifier : String?
    var isBoughtPlan : Bool
}

enum PlanBenefitStatus {
    case greenFull
    case redFull
    case greenEmpty
}

struct PlanBenefit {
    var title: String
    var highlightText: String?
    var planBenefitStatus : PlanBenefitStatus
}


class PaidPlansCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ErrorPresenter {
    
    var indicatorIndex : Int = 0
    var numberOfPlans : Int = 0
    
    var paidPlanData : PaidPlan

    init(plan : PaidPlan) {
        paidPlanData = plan
        super.init(collectionViewLayout: HowToCollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.text = Localization.shared.upgrade_plane_standard_select_plan.capitalized
        titleLabel.textColor = UIColor(named: "couponNavTitleTextColor")
        return titleLabel
    }()
           
    let nav = UINavigationBar()

    func addTopNav() {
        
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "couponNavLeftButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        
        view.addSubview(nav)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: nav)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.collectionView!)
        view.addConstraintsWithFormat(format: "V:[v0][v1]", views: nav, self.collectionView!)
        nav.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let standaloneItem = UINavigationItem()
        standaloneItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        standaloneItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: .normal)
        standaloneItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: .highlighted)
        standaloneItem.titleView = headerLabel
        nav.items = [standaloneItem]

        initialNavStyle()
    }
    
    func initialNavStyle() {
        nav.shadowImage = nil
        nav.tintColor = UIColor(named: "navTintColor")
        nav.barTintColor = UIColor(named: "navBackgroundColor")
        nav.isTranslucent = false
        self.nav.setBackgroundImage(nil, for: .default)
        resetIfNeeded()
    }
    
    
    func resetIfNeeded() {
         if #available(iOS 13.0, *) {
             self.traitCollection.performAsCurrent {
                self.nav.tintColor = UIColor(named: "navTintColor")
                self.nav.barTintColor = UIColor(named: "navBackgroundColor")

                 if traitCollection.userInterfaceStyle == .light {
                    self.nav.shadowImage = nil
                    self.nav.setBackgroundImage(nil, for: .default)
                 } else {
                     self.nav.setBackgroundImage(#imageLiteral(resourceName: "navBackground").resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
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
    
    
    @objc func closeViewController() {
        self.dismiss(animated: true, completion: {
            if let loginVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? XpertNavigationController)?.viewControllers.first as? LoginViewController {
                loginVC.loginButton(isEnabled: true)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopNav()
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView!.register(PlanBenefitCell.self, forCellWithReuseIdentifier: "PlanBenefitCell")
        self.collectionView!.register(PlanDetailsCell.self, forCellWithReuseIdentifier: "PlanDetailsCell")
        self.collectionView!.register(PlanHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlanHeaderView")
        (self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView?.contentInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        
        addPlanButton()
        addGradientView()

    }
    
    func addGradientView() {

        let terms = TermsView()
        terms.privacyButton.addTarget(self, action: #selector(showPrivacyPolicy(sender:)), for: .touchUpInside)
        terms.termsButton.addTarget(self, action: #selector(showTerms(sender:)), for: .touchUpInside)
        view.addSubview(terms)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: terms)
        view.addConstraintsWithFormat(format: "V:[v0]-[v1]-12-[v2]", views: collectionView, terms, planButton!)
        
        let gradientView = LinearGradientView(frame: .zero)
        view.addSubview(gradientView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: gradientView)
        view.addConstraintsWithFormat(format: "V:[v0(140)][v1]", views: gradientView, terms)

    }
    
    @objc func showPrivacyPolicy(sender: UIButton) {
        let webVC = SFSafariViewController(url: URL(string: "https://dynarisk.com/privacy-policy")!)
        self.present(webVC, animated: true, completion: nil)
    }
    
    @objc func showTerms(sender: UIButton) {
        let webVC = SFSafariViewController(url: URL(string: "https://dynarisk.com/terms-of-usage")!)
        self.present(webVC, animated: true, completion: nil)
    }
    
    var planButton : PlanButton?
    
    func addPlanButton() {
        planButton = PlanButton(title: Localization.shared.upgrade_plane_standard_select_plan.uppercased(), image: nil, backgroundColor: UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1), textColor: .white)
        planButton?.titleLabel?.font = planButton!.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 21))
        planButton?.heightAnchor.constraint(equalToConstant: 55).isActive = true
        planButton?.translatesAutoresizingMaskIntoConstraints = false
        planButton?.addTarget(self, action: #selector(changePlanAction), for: .touchUpInside)
        setupButtonTitle()

        view.addSubview(planButton!)
        
        let guide = self.view.safeAreaLayoutGuide
        planButton?.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: planButton!)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: planButton!)
        }
        NSLayoutConstraint(item: planButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupButtonTitle() {
        planButton?.setTitle(Localization.shared.upgrade_plane_standard_select_plan.uppercased(), for: .normal)
    }
    
    
    @objc func changePlanAction() {
        PaidPlansCollectionViewController.selectPlan(paidPlanUuid: paidPlanData.uuid) { (success) in
            if success == true {
                self.shopSuccessPopup(title: Localization.shared.popup_coupon_plan_title, subtitle: Localization.shared.popup_coupon_plan_subtitle)
            } else {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: "", completion: {})
            }
        }
    }
    
    func shopSuccessPopup(title : String, subtitle : String) {
        let popup = getPopupFor(title: title, subtitle: subtitle)
        self.present(popup, animated: true, completion: nil)
    }
    
    func getPopupFor(title: String, subtitle: String) -> CenterPopupViewController {
        let popup = CenterPopupViewController(icon: #imageLiteral(resourceName: "donecheck_ill_sml_light"), title: title, subtitle: subtitle)
        popup.modalPresentationStyle = .custom
        popup.transitioningDelegate = popup.animator
        popup.closeButton.addTarget(self, action: #selector(closePopupAction), for: .touchUpInside)
        return popup
    }
    
    @objc func closePopupAction() {
        self.dismiss(animated: true, completion: {
            self.navigationController!.dismiss(animated: true, completion: nil)
            if let loginVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? XpertNavigationController)?.viewControllers.first as? LoginViewController {
                loginVC.dashboardVC()
            }
        })
    }
    
    
    static func selectPlan(paidPlanUuid: String, completion: @escaping ((Bool?)->())) {
                
        guard let url = CyberExpertAPIEndpoint.selectPlan.url() else { completion(nil); return  }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "plan_option_uuid": paidPlanUuid
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            print("SELECTED PLAN :", String(data: data!, encoding: .utf8), paidPlanUuid)
            if error != nil { completion(false); return }
            completion(true)
        }
        
    }
    
    
    
    
    
    
    
    // MARK: Header Stuff
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlanHeaderView", for: indexPath) as! PlanHeaderView
        headerView.headerLabel.text = indexPath.section == 0 ? "" : Localization.shared.plan_detail_what_you_get.uppercased()
        headerView.headerLabel.sizeToFit()        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: section == 0 ? .leastNonzeroMagnitude : collectionView.getCorrectSize(60, 60, 74))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNonzeroMagnitude : 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) : UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 2 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return section == 0 ? 1 : paidPlanData.planBenefits.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanDetailsCell", for: indexPath) as! PlanDetailsCell
            cell.widthConstraint?.constant = collectionView.bounds.size.width
            cell.numberOfItems = numberOfPlans
            cell.data = paidPlanData
            cell.indicatorIndex = indicatorIndex
            cell.updateUI()
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanBenefitCell", for: indexPath) as! PlanBenefitCell
        cell.data = paidPlanData.planBenefits[indexPath.item]
        cell.widthConstraint?.constant = collectionView.bounds.size.width - 30
        cell.leftConstraint?.constant = (collectionView.bounds.size.width * 0.2) / 2
        return cell
    }

}


class PlanHeaderView: UICollectionReusableView {
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(named: "paidPlansSectionTextColor")
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        headerLabel.font = headerLabel.font.withSize(getCorrectSize(12, 12, 14))
        
        let containerView = UIView()
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:[v0(\(min(UIScreen.main.bounds.width, 530)))]", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        containerView.addSubview(headerLabel)
        containerView.addConstraintsWithFormat(format: "H:|-30-[v0]-10-|", views: headerLabel)
        NSLayoutConstraint(item: headerLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        addBorder(top: true)
        addBorder(top: false)
    }
    
    func addBorder(top : Bool) {
        let separator : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(red: 59/255, green: 72/255, blue: 84/255, alpha: 1)
            view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
            return view
        }()
        addSubview(separator)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separator)
        if top == true { addConstraintsWithFormat(format: "V:|[v0]", views: separator) } else { addConstraintsWithFormat(format: "V:[v0]|", views: separator) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class PlanDetailsCell : UICollectionViewCell {
    
    var data : PaidPlan?
    var numberOfItems : Int = 0
    var indicatorIndex : Int = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        planIndicatorView.setupItems()
        priceLabel.sizeToFit()
        periodLabel.sizeToFit()
        layoutIfNeeded()
    }
    
    func updateUI() {
        guard let data = data else { return }
        priceLabel.text = "\(data.pricePerYear ?? ((data.pricePerMonth ?? 0) * 12).round(to: 2))"
        priceLabel.sizeToFit()
        planButton.setTitle(data.type.rawValue, for: .normal)
        planIndicatorView.numberOfItems = numberOfItems
        planIndicatorView.setupItems()
        planIndicatorView.setSelectedAt(index: indicatorIndex)
    }
    
    let planButton : SquareButton = {
        let button = SquareButton(title: "STANDART PLAN", image: nil, backgroundColor: UIColor(named: "paidPlansPlanNameButtonBgColor")!, textColor: UIColor(named: "paidPlansPlanNameButtonTextColor")!)
        button.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 10)
        button.contentEdgeInsets = .init(top: 4, left: 10, bottom: 4, right: 10)
        button.sizeToFit()
        return button
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 36)
        label.textColor = UIColor(named: "paidPlansPriceTextColor")
        label.textAlignment = .left
        label.text = "0.67"
        return label
    }()
    
    let poundSignLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 20)
        label.textColor = UIColor(named: "paidPlansPriceTextColor")
        label.text = "£"
        return label
    }()
    
    let periodLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 14)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.textAlignment = .left
        label.text = "/ "+Localization.shared.year
        return label
    }()
    
    let planIndicatorView = CurrentPlanIndicatorView(isVIP: false)
    
    var widthConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        planIndicatorView.setSelectedAt(index: 0)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width)
        widthConstraint?.priority = .init(777)
        widthConstraint?.isActive = true
        
        let height = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        height.priority = .init(rawValue: 777)
        height.isActive = true
        
        contentView.addSubview(planButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(poundSignLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(planIndicatorView)
        
        contentView.addConstraintsWithFormat(format: "V:|-25-[v0]-10@777-[v1]-1-[v2]-6-[v3(10)]", views: planButton, priceLabel, periodLabel, planIndicatorView)
        NSLayoutConstraint(item: planButton, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: priceLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: periodLabel, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: planIndicatorView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        contentView.addConstraintsWithFormat(format: "V:[v0(18)]", views: poundSignLabel)
        NSLayoutConstraint(item: poundSignLabel, attribute: .top, relatedBy: .equal, toItem: priceLabel, attribute: .top, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: poundSignLabel, attribute: .right, relatedBy: .equal, toItem: priceLabel, attribute: .left, multiplier: 1, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CurrentPlanIndicatorView: UIView {
    
    var numberOfItems = 0
    private var isVIP : Bool
    
    init(isVIP : Bool) {
        self.isVIP = isVIP
        super.init(frame: .zero)
        setupItems()
    }
    
    var items : [UIImageView] = []
    
    let mainStackView = UIStackView(arrangedSubviews: [])

    func setupItems() {
        
        if items.count > 0 {
            mainStackView.arrangedSubviews.forEach { (imageView) in
                (imageView as? UIImageView)?.image = #imageLiteral(resourceName: "silder_unselected_ic")
            }
            return
        }
        
        mainStackView.arrangedSubviews.forEach({ sub in
            sub.removeFromSuperview()
        })
        mainStackView.removeFromSuperview()

        mainStackView.spacing = 0
        
        for _ in 0..<numberOfItems {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = #imageLiteral(resourceName: "silder_unselected_ic")
            mainStackView.addArrangedSubview(imageView)
            items.append(imageView)
        }
        
        addSubview(mainStackView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStackView)
        NSLayoutConstraint(item: mainStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
    }
    
    func setViewForVIP() {
        isVIP = true
        for item in items { item.image = #imageLiteral(resourceName: "vip_indicator_off") }
    }
    
    func setSelectedAt(index : Int) {
        for (i, item) in items.enumerated() { item.image = i == index ? (isVIP == true ? #imageLiteral(resourceName: "vip_indicator_on") : #imageLiteral(resourceName: "slider_selected_ic")) : (isVIP == true ? #imageLiteral(resourceName: "vip_indicator_off") : #imageLiteral(resourceName: "silder_unselected_ic")) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class PlanBenefitCell : UICollectionViewCell {
    
    var data : PlanBenefit? { didSet{ updateUI() }}
    
    func updateUI() {
        guard let data = data else { return }
        roundStatusImageView.setupImageView(with: .greenFull /* data.planBenefitStatus */)
        
        if let highlight = data.highlightText, highlight.count > 0 {
            let attr = NSMutableAttributedString(string: "\(highlight ) \(data.title)" )
            attr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: 0, length: data.highlightText?.count ?? 0))
            benefitLabel.attributedText = attr
        } else {
            benefitLabel.text = data.title
        }
        
        benefitLabel.sizeToFit()
    }
    
    override func prepareForReuse() {

    }
    
    let benefitLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 15)
        label.textColor = UIColor(named: "paidPlansPlanBenefitTextColor")
        label.textAlignment = .left
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    let containerView = UIView()
    let roundStatusImageView = StatusImageView(frame: .zero)
    
    var widthConstraint : NSLayoutConstraint?
    var heightConstraint : NSLayoutConstraint?
    
    var leftConstraint : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        benefitLabel.font = benefitLabel.font.withSize(getCorrectSize(15, 15, 18))
        
        widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.size.width - 30)
        widthConstraint?.priority = .init(rawValue: 777)
        widthConstraint?.isActive = true
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 24)
        heightConstraint?.priority = .init(777)
        heightConstraint?.isActive = true
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|[v0]|", views: contentView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: contentView)
        
        contentView.addSubview(containerView)
        
        contentView.addConstraintsWithFormat(format: "H:[v0]-0@777-|", views: containerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)
        
        leftConstraint = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0)
        leftConstraint?.isActive = true
        
        containerView.addSubview(roundStatusImageView)
        containerView.addSubview(benefitLabel)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0(24)]-12@777-[v1]-10-|", views: roundStatusImageView, benefitLabel)
        containerView.addConstraintsWithFormat(format: "V:[v0(24)]", views: roundStatusImageView)
        NSLayoutConstraint(item: roundStatusImageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
   }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StatusImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 24).isActive = true
        heightAnchor.constraint(equalToConstant: 24).isActive = true
        contentMode = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView(with status : PlanBenefitStatus) {
        switch status {
        case .greenEmpty:
            image = #imageLiteral(resourceName: "green_empty_ic")
            break
        case .greenFull:
            image = #imageLiteral(resourceName: "green_ic")
            break
        case .redFull:
            image = #imageLiteral(resourceName: "red_ic")
            break
        }
    }
}



class TermsView: UIView {
    
    let termsTextView : UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        textView.text = Localization.shared.buy_plan_explainer
        textView.font = UIFont(name: "Muli-Regular", size: 11)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
    }()
    
    class LegalButton: UIButton {
  
        init(title: String) {
            super.init(frame: .zero)
            setTitle(title, for: .normal)
            backgroundColor = .clear
            setTitleColor(UIColor(named:"paidPlanLegalButtonTextColor"), for: .normal)
            titleLabel?.font = UIFont(name: "Muli-Regular", size: 10)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let termsButton = LegalButton(title: Localization.shared.terms_of_service)
    let privacyButton = LegalButton(title: Localization.shared.privacy_policy)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        addSubview(termsTextView)
        
        if isSmallScreenSize == true {
            addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: termsTextView)
        } else {
            addConstraintsWithFormat(format: "H:[v0(\(calculatedNewScreenWidth))]", views: termsTextView)
        }
        NSLayoutConstraint(item: termsTextView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        addSubview(termsButton)
        addSubview(privacyButton)
        
        NSLayoutConstraint(item: termsButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: privacyButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-[v1]-10-[v2]-10-|", views: termsTextView, termsButton, privacyButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
