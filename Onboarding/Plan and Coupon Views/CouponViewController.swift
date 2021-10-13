//
//  CouponViewController.swift
//  Xpert
//
//  Created by Darius on 26/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class CouponNavViewController:  NavViewController, ErrorPresenter {
    
    let couponView = CouponView(frame: .zero)
    
    let signUpButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.don_t_have_a_code.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(noCouponAction), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Init
    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: nil, subtitle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        resetIfNeeded()
    }
    
    // MARK:- Setup UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        setupNav()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        let header = HeaderLabel(text: Localization.shared.coupon_got_a_coupon_, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 36))
        if view.isSmallScreenSize == false { header.textAlignment = .center }

        couponView.addCouponButton.addTarget(self, action: #selector(checkCoupon), for: .touchUpInside)
        couponView.couponTextField.font = couponView.couponTextField.font?.withSize(view.getCorrectSize(15, 15, 20))
        couponView.addCouponButton.titleLabel?.font = couponView.addCouponButton.titleLabel?.font.withSize(view.getCorrectSize(10, 10, 14))
        
        signUpButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        signUpButton.titleLabel?.font = UIFont(name: "Muli-ExtraBold", size: 15)

        _ = [header, couponView, signUpButton].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(14, 14, 20)
        mainStack.setCustomSpacing(view.getCorrectSize(28, 28, 36), after: header)
        mainStack.setCustomSpacing(view.getCorrectSize(24, 24, 32), after: couponView)
        
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: view.getCorrectSize(48, 140, 140)).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    
    @objc func closeViewController() {
        self.dismiss(animated: true, completion: {
            if let loginVC = ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? UINavigationController)?.viewControllers.first as? LoginViewController {
                loginVC.loginButton(isEnabled: true)
            }
        })
    }
        
    @objc func checkCoupon() {
        self.signUpButton.isEnabled = false
        couponView.startLoading()
        CouponNavViewController.check(with: self.couponView.couponTextField.text ?? "", completion: { data, errorString in
            self.couponView.stopLoading()
            if let data = data {
                if data == true {
                    DispatchQueue.main.async {
                        self.showCouponPlans()
                        self.signUpButton.isEnabled = true 
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentError(viewModel: ErrorViewModel(errorText: [errorString ?? Localization.shared.error_occured]))
                        self.signUpButton.isEnabled = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.presentError(viewModel: ErrorViewModel(errorText: [errorString ?? Localization.shared.coupon_not_applied]))
                    self.signUpButton.isEnabled = true
                }
            }
        })
    }
    
    @objc func showCouponPlans() {
        let paymentViewController = PaidPlansViewController()
        paymentViewController.planSelectedCompletion = {
            let welcomeVC = ScanViewController(isTrial: false)
            self.navigationController?.pushViewController(welcomeVC, animated: true)
        }
        self.navigationController?.pushViewController(paymentViewController, animated: true)
    }
    
    @objc func noCouponAction() {
        DispatchQueue.main.async {
            let iapVC = IAPPaidPlansViewController()
            self.navigationController?.pushViewController(iapVC, animated: true)
        }
    }
    
    
    static func check(with coupon : String, completion: @escaping ((Bool?, String?)->())) {
        guard let url = CyberExpertAPIEndpoint.applyCoupon.url() else { completion(nil, nil); return  }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        
        let parameters: [String: Any] = [
            "name": coupon
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
                        
            if error != nil || data == nil { completion(nil, error?.localizedDescription); return }
            do {
                let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                if let result = json?["result"] as? Bool, result == true {
                    completion(true, nil)
                    return
                } else if let errors = json?["errors"] as? [String : Any] {
                    if let name = errors["name"] as? [String : Any] {
                        for (_,a) in name {
                            completion(false, a as? String)
                            return
                        }
                    }
                }
            } catch {
                completion(false, nil)
                return
            }
            completion(nil, nil)
        }
    }
    
    
    // MARK: Navigation Bar Setup
    
    let headerLabel : UILabel = {
       let titleLabel = UILabel()
       titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
       titleLabel.text = Localization.shared.sign_up_to_dynarisk.doubleBracketReplace(with: "Dynarisk")
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
        self.navigationItem.titleView = headerLabel

        initialNavStyle()
    }
    
    func initialNavStyle() {
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        resetIfNeeded()
    }
    
    func resetIfNeeded() {
         if #available(iOS 13.0, *) {
             self.traitCollection.performAsCurrent {
                self.navigationController?.navigationBar.tintColor = UIColor(named: "navTintColor")
                self.navigationController?.navigationBar.barTintColor = UIColor(named: "navBackgroundColor")
                 if traitCollection.userInterfaceStyle == .light {
                    self.navigationController?.navigationBar.shadowImage = nil
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
    
}










// MARK :- Coupon View

class CouponView: UIView {
    
    let couponTextField : UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Muli-Regular", size: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor =  UIColor(named: "couponTextFieldTextColour")
        textField.attributedPlaceholder = NSAttributedString(string: Localization.shared.forgot_coupon_code+"...", attributes: [NSAttributedString.Key.strokeColor : UIColor(named: "couponTextFieldTextColour")!])
        if #available(iOS 13.0, *) {
            textField.overrideUserInterfaceStyle = .light
        }
        textField.autocapitalizationType = .allCharacters
        return textField
    }()
    
    let addCouponButton : SquareButton = {
        let button = SquareButton(title: Localization.shared.forgot_add_coupon.uppercased(), image: nil, backgroundColor: UIColor(red: 227/255, green: 242/255, blue: 249/255, alpha: 1), textColor: UIColor(red: 98/255, green: 177/255, blue: 220/255, alpha: 1))
        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 10)
        button.tintColor = .white
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 3
        
        let middleDividerView = UIView()
        middleDividerView.translatesAutoresizingMaskIntoConstraints = false
        
        let circleLeft = CircleView(frame: .zero)
        let circleRight = CircleView(frame: .zero)
        let dashedLine = DashedLine(frame: .zero)
        
        middleDividerView.addSubview(circleLeft)
        middleDividerView.addSubview(circleRight)
        middleDividerView.addSubview(dashedLine)
        
        NSLayoutConstraint(item: circleLeft, attribute: .centerX, relatedBy: .equal, toItem: middleDividerView, attribute: .left, multiplier: 1, constant: -4).isActive = true
        NSLayoutConstraint(item: circleRight, attribute: .centerX, relatedBy: .equal, toItem: middleDividerView, attribute: .right, multiplier: 1, constant: 4).isActive = true
        
        middleDividerView.addConstraintsWithFormat(format: "H:[v0(28)]-9-[v1]-10-[v2(28)]", views: circleLeft, dashedLine, circleRight)
        middleDividerView.addConstraintsWithFormat(format: "V:|[v0]|", views: circleLeft)
        middleDividerView.addConstraintsWithFormat(format: "V:|[v0]|", views: dashedLine)
        middleDividerView.addConstraintsWithFormat(format: "V:|[v0]|", views: circleRight)
        

        addSubview(couponTextField)
        addSubview(middleDividerView)
        addSubview(addCouponButton)
        
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: couponTextField)
        addConstraintsWithFormat(format: "H:|[v0]|", views: middleDividerView)
        addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: addCouponButton)

        addConstraintsWithFormat(format: "V:|-\(getCorrectSize(18, 18, 26))-[v0(\(getCorrectSize(19, 19, 28)))]-\(getCorrectSize(10, 10, 14))-[v1(\(getCorrectSize(28, 28, 28)))]-\(getCorrectSize(4, 4, 6))-[v2(\(getCorrectSize(28, 28, 36)))]-\(getCorrectSize(20, 20, 26))-|", views: couponTextField, middleDividerView, addCouponButton)

    }
    
    lazy var loader = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    func startLoading() {
        addCouponButton.setTitle("", for: .normal)
        addCouponButton.addSubview(loader)
        NSLayoutConstraint(item: loader, attribute: .centerX, relatedBy: .equal, toItem: addCouponButton, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loader, attribute: .centerY, relatedBy: .equal, toItem: addCouponButton, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        loader.startAnimating()
    }
    
    func stopLoading() {
        loader.stopAnimating()
        addCouponButton.setTitle(Localization.shared.forgot_add_coupon.uppercased(), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class CircleView : UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.bounds.size.width / 2
        }
    }
    
    class DashedLine : UIView {
        
        let path = UIBezierPath()

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
        }
        
        override func draw(_ rect: CGRect) {
            path.move(to: CGPoint(x: 0, y: (rect.size.height / 2) - 2))
            path.addLine(to: CGPoint(x: rect.size.width, y: (rect.size.height / 2) - 2))
            UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1).setStroke()
            path.lineWidth = 0.4
            let dashPattern : [CGFloat] = [6, 6]
            path.setLineDash(dashPattern, count: 2, phase: 0)
            path.lineCapStyle = CGLineCap.round
            path.lineCapStyle = .butt
            path.stroke()
        }
        
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}



