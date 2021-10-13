//
//  PaidPlansViewController.swift
//  Xpert
//
//  Created by Darius on 27/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class PaidPlansViewController: UIViewController {
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Localization.shared.upgrade_plan
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(named: "paidPlansNavTitleTextColor")
        return titleLabel
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    var planSelectedCompletion : (()->())?

    @objc func closeViewController() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: planSelectedCompletion)
        }
        
        if let loginVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UINavigationController)?.viewControllers.first as? LoginViewController {
            loginVC.loginButton(isEnabled: true)
        }
    }
    
    var paidPlans : [PaidPlan] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let loadingView = XpertLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        setupLoadingView()
                        
        getPlans { (error) in
            self.loadingView.stopAnimating()
            self.setupPaidPlansViewController()
        }
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 100).isActive = true 
        loadingView.startAnimating()
    }
    
    func setupPaidPlansViewController() {
        let pageVC = PaidPlansPageController(plans: paidPlans)
        addChild(pageVC)
        pageVC.didMove(toParent: self)
        view.addSubview(pageVC.view)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: pageVC.view)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: pageVC.view)
    }


    func getPlans(completion: @escaping (Error?) -> ()) {
            
        PaidPlansViewController.getPlansRequest { (paidPlans, success) in
            
            if success != true { completion(NetworkError.generic); return }
            self.paidPlans = paidPlans
            completion(nil)
        }
            
    }
        
    
    static func getPlansRequest(completion: @escaping (([PaidPlan], Bool) -> ())) {
        guard let url = CyberExpertAPIEndpoint.plans.url() else { return completion([], false) }
        
        print("URLAS :", url.absoluteString)
        
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
             
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            print("DATAA :", String(data: data!, encoding: .utf8))
            
            guard let data = data else { completion([], false); return }
                                 
            if let json = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]) as [String : Any]??), let plans = json?["plans"] as? [[String : Any]] {
                                
                var plansFromRequest : [PaidPlan] = []
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
                            guard let slug = feature["name"] as? String else { continue }
                            var title = Localization.shared.getTranslationFor(slug: "plan-feature:"+slug)
                            
                            if let value = feature["value"] as? String {
                                title = title.doubleBracketReplace(with: value)
                            }
                            
                            if title == "" { continue }
                            let highlight = ""
                            let status = PlanBenefitStatus.redFull
                            let benefit = PlanBenefit(title: title, highlightText: highlight, planBenefitStatus: status)
                            planBenefits.append(benefit)
                        }
                    }
                         
                    let planData = PaidPlan(type: PlanType(string: name), pricePerMonth: price, pricePerYear: nil, planBenefits: planBenefits, subtitle: "no text here..", priceWithCoupon: nil, priceWithDiscount: "1.99", uuid: uuid, isBoughtPlan: false)
                    plansFromRequest.append(planData)
                }
                completion(plansFromRequest, true)
                return
            } else if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any], let data = json["data"] as? [String : Any], let code = data["code"] as? Int, code == 401 {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        PaidPlansViewController.getPlansRequest(completion: completion)
                        return
                    } else {
                        completion([], false)
                    }
                })
            } else {
                completion([], false)
            }
            
        }
    }
        

}

class OpaqueNavigationBar : UINavigationController {
    
    var blurBgView : AnimationBackgroundView?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNav()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func setupNav() {
        self.navigationBar.tintColor = .white
        self.navigationBar.barTintColor = .clear
        
        let image = #imageLiteral(resourceName: "nav_bg_view")
        let navbarImage = image.stretchableImage(withLeftCapWidth: 1, topCapHeight: 1)
        self.navigationBar.setBackgroundImage(navbarImage, for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                
        blurBgView = AnimationBackgroundView(frame: CGRect(x: 0, y: -statusBarHeight, width: self.navigationBar.bounds.width, height: 2 * statusBarHeight + self.navigationBar.frame.maxY))
        self.navigationBar.insertSubview(blurBgView!, at: 0)
        
        blurBgView!.layer.zPosition = -1;
        blurBgView!.isUserInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AnimationBackgroundView : UIView {
    
    var animator : UIViewPropertyAnimator?
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    override init(frame: CGRect) {
        super.init(frame: frame)
        visualEffectView.frame = frame
        addSubview(visualEffectView)
        
        visualEffectView.effect = nil
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
        }
        animator?.stopAnimation(true)
        animator?.fractionComplete = 0.1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
