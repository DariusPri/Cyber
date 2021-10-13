//
//  TermsViewController.swift
//  Xpert
//
//  Created by Darius on 26/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import CDMarkdownKit

class TermsViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
    
    let termsDetailedLabel : UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Muli-Regular", size: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor(named: "defaultTextColor")!
        textView.backgroundColor = .clear
        textView.textContainerInset = .init(top: 0, left: 0, bottom: 100, right: 0)
        textView.isEditable = false
        textView.isSelectable = true
        return textView
    }()
    
    // MARK:- Init
    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: Localization.shared.sign_up_to_dynarisk.doubleBracketReplace(with: "Dynarisk"), subtitle: Localization.shared.terms_and_conditions)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))

        termsDetailedLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(14, 14, 18))
        
        addMainStack()
        addGradientView()
        setupBottomButtons()
        addLoader()
        getTerms()

    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupCorrectTermsForColorMode()
    }
    
    // MARK:- Setup UI

    
    var loader : UIActivityIndicatorView?
    
    func addMainStack() {
        _ = [termsDetailedLabel].map({ mainStack.addArrangedSubview($0) })

        mainStack.axis = .vertical
        mainStack.spacing = 14
        
        view.addSubview(mainStack)
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=500)]-(>=15,==15@900)-|", views: mainStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: 32).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true

    }
    
    func addGradientView() {
        let gradientView = LinearGradientView(frame: .zero)
        view.addSubview(gradientView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: gradientView)
        view.addConstraintsWithFormat(format: "V:[v0(150)]|", views: gradientView)
        gradientView.setNeedsLayout()
        gradientView.layoutIfNeeded()
    }
    
    func setupBottomButtons() {
        let signInButton = SquareButton(title: Localization.shared.accept_and_continue.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)
        signInButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        signInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        signInButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(15, 15, 21))
             
        let closeButton = SquareButton(title: "", image: #imageLiteral(resourceName: "close_button"), backgroundColor: .white, textColor: .white)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        closeButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.textInputBorderColor.cgColor
             
        let mainBottomNavStack = UIStackView(arrangedSubviews: [closeButton, signInButton])
        mainBottomNavStack.spacing = 15
        view.addSubview(mainBottomNavStack)
             
        let guide = self.view.safeAreaLayoutGuide
        mainBottomNavStack.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        if view.isSmallScreenSize == true {
            view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainBottomNavStack)
        } else {
            view.addConstraintsWithFormat(format: "H:[v0(\(view.calculatedNewScreenWidth))]", views: mainBottomNavStack)
        }
        NSLayoutConstraint(item: mainBottomNavStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func addLoader() {
        
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                loader = UIActivityIndicatorView(style: .medium)
            } else {
                loader = UIActivityIndicatorView(style: .large)
            }
        } else {
            loader = UIActivityIndicatorView(style: .gray)
        }
        
        self.view.addSubview(loader!)
        loader?.startAnimating()
        
        loader?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loader!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loader!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
    }
    
    @objc func registerAction(sender: UIButton) {
        sender.isEnabled = false
        
        register { (success) in
            if success == false {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {
                    DispatchQueue.main.async {
                        if let vc = self.navigationController?.viewControllers[1] {
                            self.navigationController?.popToViewController(vc, animated: true)
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                })
                sender.isEnabled = true
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(VerifyEmailViewController(), animated: true)
                    sender.isEnabled = true
                }
            }
        }
    }
    
    @objc func closeButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func register(completion: @escaping (Bool) -> ()) {
        guard let email = (self.navigationController as? XpertNavigationController)?.registrationData?.email,
            let firstName = (self.navigationController as? XpertNavigationController)?.registrationData?.first_name,
            let lastName = (self.navigationController as? XpertNavigationController)?.registrationData?.last_name,
            let password = (self.navigationController as? XpertNavigationController)?.registrationData?.password,
            let phoneNumber = (self.navigationController as? XpertNavigationController)?.registrationData?.phone_number,
            let countryCode = (self.navigationController as? XpertNavigationController)?.registrationData?.countryCode else { return }
        
        guard let url = CyberExpertAPIEndpoint.register.url() else { return completion(false) }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
                
        let parameters: [String: Any] = [
            "email": email,
            "first_name": firstName,
            "last_name": lastName,
            "password": password,
            "phone_number": phoneNumber,
            "country_code" : countryCode.dropFirst()
        ]
                
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(request: request) { (data, _, error) in
            
            guard let data = data else { completion(false); return }
            
            do {
                let json  = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                if let status = json?["status"] as? Bool, status == false {
                    var errorList : [String] = []
                    if let errorDict = json?["errors"] as? [String : Any] {
                        for (key,value) in errorDict {
                            if let vv = value as? [String : Any] {
                                for (_, v) in vv {
                                    errorList.append("\(key) : \(v as! String)")
                                }
                            }
                        }
                    }
                    self.presentSimpleOKError(withTitle: Localization.shared.error_occured.capitalized, andSubtitle: errorList.count > 1 ? errorList.joined(separator: ". ") : errorList.first ?? "") {}
                }
                if let userObj = json?["user"] as? [String : Any] {
                    if let registrationHash = userObj["registration_hash"] as? String {
                        (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.registrationHash = registrationHash
                        completion(true)
                        return
                    }
                }
            } catch {
                completion(false); return
            }
            completion(false)
        }
        
    }
    
    var content = ""
    

    
    func setupCorrectTermsForColorMode() {
        
        var textColor : UIColor = UIColor(red: 25/255, green: 44/255, blue: 60/255, alpha: 1)
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                textColor = .white
            }
        }
        
        let markdownParser : CDMarkdownParser = {
            let hugeScreen = UIScreen.main.bounds.size.width > 500
            let parser = CDMarkdownParser(font: UIFont(name: "Muli-Regular", size: hugeScreen == true ? 14 : 12)!,
                                         boldFont: UIFont(name: "Muli-Bold", size: hugeScreen == true ? 14 : 12),
                                         italicFont: UIFont(name: "Muli-Italic", size: hugeScreen == true ? 14 : 12),
                                         fontColor: textColor,
            backgroundColor: UIColor.clear)
            parser.link.color = CDColor.mainBlue
            parser.automaticLink.color = UIColor.mainBlue
            parser.header.font = UIFont(name: "Muli-Regular", size: hugeScreen == true ? 10 : 8)
            parser.header.fontIncrease = 1
            parser.automaticLinkDetectionEnabled = true
            parser.automaticLink.color = CDColor.mainBlue
            return parser
        }()
        
        
        let data = markdownParser.parse(content)
        self.termsDetailedLabel.delegate = self
        self.termsDetailedLabel.attributedText = data
    }
    
    func getTerms() {
        guard let url = CyberExpertAPIEndpoint.termsAndPartners.url() else { return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
                
        let parameters: [String: Any] = ["domain" : "app.dynarisk.com"]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
          
        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, _, _) in
            if let data = data, let json  = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                if let partherSettings = json?["partner_settings"] as? [String : Any] {
                    if let settings = partherSettings["settings"] as? [String : Any] {
                        if let content = settings["partner.pp.content"] as? String {
                            self.content = content
                            DispatchQueue.main.async {
                                self.loader?.stopAnimating()
                                self.setupCorrectTermsForColorMode()
                            }
                            return
                        }
                    }
                }
            }
            self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
}

extension TermsViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
}

class LinearGradientView: UIView {
    
    let gradient: CAGradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        backgroundColor = UIColor(white: 1, alpha: 0)
        gradient.locations = [0.0 , 0.7, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.colors = [UIColor(named: "termsConditionsGradientToColor")!.withAlphaComponent(0).cgColor, UIColor(named: "termsConditionsGradientToColor")!.withAlphaComponent(0.8).cgColor]
        layer.addSublayer(gradient)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
