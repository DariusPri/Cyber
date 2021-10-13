//
//  DeleteAccountViewController.swift
//  Xpert
//
//  Created by Darius on 11/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class DeleteAccountViewController : NavViewController, ErrorPresenter {
    
    let cancelButton = SquareButton(title: Localization.shared.cancel.uppercased(), image: nil, backgroundColor: UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1), textColor: .white)
    let deleteAccButton = SquareButton(title: Localization.shared.delete_account.uppercased(), image: nil, backgroundColor: .white, textColor: UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1))
    
    var deleteValues : [String] = []
    
    func getDeleteReasons() {
        guard let url = CyberExpertAPIEndpoint.getDeleteReasons.url() else { errorOccuredPopup(); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if error != nil {
                self.errorOccuredPopup()
            }
            
            do {
                guard let d = data, let json  = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? [[String : Any]] else { self.errorOccuredPopup(); return }
                
                struct ReasonData {
                    var uuid : String
                    var reason : String
                    var position : Int
                }
                
                var reasonDatas : [ReasonData] = []
                
                for a in json {
                    if let uuid = a["uuid"] as? String, let reason = a["reason"] as? String, let position = a["position"] as? Int {
                        reasonDatas.append(ReasonData(uuid: uuid, reason: reason, position: position))
                    }
                    reasonDatas.sort(by: {$0.position < $1.position})
                    self.deleteValues = reasonDatas.map({ $0.reason })
                }

                self.addReasonView()
            } catch {
                self.errorOccuredPopup()
            }
        }
    }
    
    func deleteAccRequest() {

        guard let url = CyberExpertAPIEndpoint.deleteAcc.url(), let reason = reasonView?.selectedReason() else { self.errorOccuredPopup(); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "delete_user" : true,
            "delete_reason" : reason
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient().sendRequest(request: request) { (data, response, error) in
            if error != nil || (response as! HTTPURLResponse).statusCode == 422 {
                self.errorOccuredPopup()
                return
            }
            self.dismiss(animated: true, completion: { })
        }
    }
    
    func errorOccuredPopup() {
        let confirmationVC = UIAlertController(title: Localization.shared.error_occured, message: nil, preferredStyle: UIAlertController.Style.alert)
        confirmationVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in  self.dismiss(animated: true, completion: nil) }))
        confirmationVC.view.tintColor = UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1)
        present(confirmationVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        setupNav()

        customNavBar.removeFromSuperview()

        mainStack.axis = .vertical
        mainStack.spacing = view.getCorrectSize(25, 25, 32)
        
        mainScrollView.addSubview(mainStack)
        if view.isHugeScreenSize == true {
            let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (UIScreen.main.bounds.size.width - view.getCorrectSize(600, 600, 700)) / 2
            mainScrollView.addConstraintsWithFormat(format: "H:|-\(horizontalInset)-[v0]-\(horizontalInset)-|", views: mainStack)
        } else {
            mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=600)]-(>=15,==15@900)-|", views: mainStack)
        }
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: mainScrollView, attribute: .top, multiplier: 1, constant: 15).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .bottom, relatedBy: .equal, toItem: mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        view.addConstraintsWithFormat(format: "V:|-\(view.getCorrectSize(0, 0, 24))-[v0]", views: mainScrollView)
        
        addDeleteInfoView()
        addInfoLabel()
        addButtons()
        
        getDeleteReasons()
    }
    
    func addDeleteInfoView() {
        let deleteInfoView = DeleteInfoView()
        mainStack.addArrangedSubview(deleteInfoView)
        mainStack.setCustomSpacing(35, after: deleteInfoView)
        deleteInfoView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addInfoLabel() {
        let containerView = UIView()
        
        let infoLabel = UITextView()
        infoLabel.isScrollEnabled = false
        infoLabel.text = Localization.shared.reason_for_deleting_your_account
        infoLabel.font = UIFont(name: "Muli-Regular", size: view.getCorrectSize(15, 15, 18))
        infoLabel.textColor = .black
        infoLabel.textAlignment = .left
        infoLabel.sizeToFit()
        infoLabel.backgroundColor = .clear
        infoLabel.contentInset = .zero
        
        containerView.addSubview(infoLabel)
        containerView.addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: infoLabel)
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: infoLabel)

        mainStack.addArrangedSubview(containerView)
    }
    
    var reasonView : ReasonSelectView?
    
    func addReasonView() {
        let containerView = UIView()
        reasonView = ReasonSelectView(reasons: self.deleteValues)
        containerView.addSubview(reasonView!)
        NSLayoutConstraint(item: reasonView!, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        containerView.addConstraintsWithFormat(format: "V:|[v0]|", views: reasonView!)
        mainStack.addArrangedSubview(containerView)
        NSLayoutConstraint(item: reasonView!, attribute: .width, relatedBy: .equal, toItem: mainScrollView, attribute: .width, multiplier: 1, constant: 0).isActive = true
    }
    
    func addButtons() {
        view.addSubview(cancelButton)
        view.addSubview(deleteAccButton)
        
        cancelButton.titleLabel?.font = cancelButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 18))
        deleteAccButton.titleLabel?.font = deleteAccButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 18))
        
        cancelButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        deleteAccButton.addTarget(self, action: #selector(deleteAccountAction), for: .touchUpInside)
        
        deleteAccButton.layer.borderWidth = 1
        deleteAccButton.layer.borderColor = UIColor(red: 212/255, green: 223/255, blue: 232/255, alpha: 1).cgColor
        
        let guide = self.view.safeAreaLayoutGuide
        deleteAccButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: view.getCorrectSize(-20, -20, -32)).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(\(view.getCorrectSize(55, 55, 80)))]", views: deleteAccButton)
        NSLayoutConstraint(item: deleteAccButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: cancelButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        if view.isHugeScreenSize == true {
            let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 700)) / 2
            view.addConstraintsWithFormat(format: "H:|-\(horizontalInset)-[v0]-\(horizontalInset)-|", views: cancelButton)
            view.addConstraintsWithFormat(format: "H:|-\(horizontalInset)-[v0]-\(horizontalInset)-|", views: deleteAccButton)
        } else {
            view.addConstraintsWithFormat(format: "H:|-(>=25,==25@900)-[v0(<=500)]-(>=25,==25@900)-|", views: cancelButton)
            view.addConstraintsWithFormat(format: "H:|-(>=25,==25@900)-[v0(<=500)]-(>=25,==25@900)-|", views: deleteAccButton)
        }
        view.addConstraintsWithFormat(format: "V:[v0(\(view.getCorrectSize(55, 55, 80)))]-\(view.getCorrectSize(11, 11, 16))-[v1]", views: cancelButton, deleteAccButton)
    }
    
    @objc func deleteAccountAction() {
        if let _ = reasonView?.selectedReason() {
            self.presentError(viewModel: ErrorViewModel(errorText: nil))
            deteleConfirmationPopup()
        } else {
            self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.settings_you_have_to_include_a_reason]))
        }
        
    }
    
    func deteleConfirmationPopup() {
        ((UIApplication.shared.delegate as? AppDelegate)!.window!.rootViewController! as? UINavigationController)?.setViewControllers([LoginViewController()], animated: false)
        let confirmationVC = UIAlertController(title: Localization.shared.settings_your_account_is_deleted_we_re_sorry_to_see_you_go, message: nil, preferredStyle: UIAlertController.Style.alert)
        confirmationVC.addAction(UIAlertAction(title: Localization.shared.settings_ok, style: .default, handler: { _ in
            self.deleteAccRequest()
        }))
        confirmationVC.view.tintColor = UIColor(red: 74/255, green: 161/255, blue: 213/255, alpha: 1)
        present(confirmationVC, animated: true, completion: nil)
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let headerLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Localization.shared.delete_account
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        return titleLabel
    }()
    
    func setupNav() {
        headerLabel.font = headerLabel.font.withSize(view.getCorrectSize(17, 17, 21))
        self.navigationItem.titleView = headerLabel
        self.navigationController!.navigationBar.tintColor = .white
        self.navigationController!.navigationBar.barTintColor = .white
        self.navigationController!.navigationBar.isTranslucent = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: nil, subtitle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class DeleteInfoView: UIView {
    
    let containerView = UIView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = Localization.shared.delete_account_warning
        label.textColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Muli-Regular", size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = titleLabel.font.withSize(getCorrectSize(13, 13, 19))
        
        containerView.layer.cornerRadius = 3
        containerView.backgroundColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 0.1)
        
        containerView.addSubview(titleLabel)
        containerView.addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 18))-[v0]-\(getCorrectSize(15, 15, 18))-|", views: titleLabel)
        containerView.addConstraintsWithFormat(format: "V:|-\(getCorrectSize(15, 15, 18))-[v0]-\(getCorrectSize(15, 15, 18))-|", views: titleLabel)
        
        addSubview(containerView)
        addConstraintsWithFormat(format: "H:|-\(getCorrectSize(15, 15, 18))-[v0]-\(getCorrectSize(15, 15, 18))-|", views: containerView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: containerView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ReasonSelectView: UIView {
    
    private var reasonArray : [String] = []
    
    init(reasons : [String]) {
        super.init(frame: .zero)
        reasonArray = reasons
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let topLine = horizontalLineView()
        addSubview(topLine)
        addConstraintsWithFormat(format: "H:|[v0]|", views: topLine)
        addConstraintsWithFormat(format: "V:|[v0]", views: topLine)

        let mainStack = UIStackView()
        mainStack.axis = .vertical
        
        for reason in reasonArray {
            
            let containerView = UIView()
            
            let stack = infoButton(with: reason)
            containerView.addSubview(stack)
            
            if isHugeScreenSize == true {
                let horizontalInset : CGFloat = isSmallScreenSize == true ? 0 : (UIScreen.main.bounds.size.width - getCorrectSize(600, 600, 660)) / 2
                containerView.addConstraintsWithFormat(format: "H:|-\(horizontalInset)-[v0]-\(horizontalInset)-|", views: stack)
            } else {
                containerView.addConstraintsWithFormat(format: "H:|-35-[v0]-20-|", views: stack)
            }
            
            NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            
            let topLine = horizontalLineView()
            containerView.addSubview(topLine)
            containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topLine)
            containerView.addConstraintsWithFormat(format: "V:[v0]|", views: topLine)
            
            mainStack.addArrangedSubview(containerView)
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.heightAnchor.constraint(equalToConstant: getCorrectSize(80, 80, 106)).isActive = true
            NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: mainStack, attribute: .width, multiplier: 1, constant: 0).isActive = true

        }
        
        addSubview(mainStack)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainStack)
        addConstraintsWithFormat(format: "V:|[v0]|", views: mainStack)
    }
    
    private func horizontalLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.4).isActive = true
        return view
    }
    
    var buttons : [UIButton] = []
    
    private func infoButton(with reason : String) -> UIButton {
        
        let button = UIButton()
        button.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "selector_unslected_ic_huge") : #imageLiteral(resourceName: "selector_unslected_ic"), for: .normal)
        button.setImage(isHugeScreenSize == true ? #imageLiteral(resourceName: "selector_slected_ic_huge") : #imageLiteral(resourceName: "selector_slected_ic"), for: .selected)
        button.imageView?.contentMode = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.setTitle(reason, for: .normal)
        button.titleEdgeInsets = .init(top: 0, left: getCorrectSize(20, 20, 32), bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "Muli-Regular", size: getCorrectSize(16, 16, 22))
        button.setTitleColor(UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(selectedButton(button:)), for: .touchUpInside)
        buttons.append(button)
        return button
    }
    
    @objc func selectedButton(button : UIButton) {
        for b in buttons { b.isSelected = false }
        button.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func selectedReason() -> Int? {
        for (i, b) in buttons.enumerated() { if b.isSelected == true { return i } }
        return nil
    }
    
}
