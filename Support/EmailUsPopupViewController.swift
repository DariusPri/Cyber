//
//  EmailUsPopupViewController.swift
//  Xpert
//
//  Created by Darius on 14/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class EmailUsPopupViewController: PopupViewController {
    
    let bottomContainerView = UIView()
    
    let titleTextField = DefaultTextField(placeholderText: "")
    let messageTextField = DefaultTextView()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.text = Localization.shared.subject.uppercased()
        label.sizeToFit()
        return label
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-ExtraBold", size: 12)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.text = Localization.shared.message.uppercased()
        label.sizeToFit()
        return label
    }()
    
    let explainerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Muli-Regular", size: 14)
        label.textColor = UIColor(red: 127/255, green: 137/255, blue: 145/255, alpha: 1)
        label.text = Localization.shared.forgot_security_is_our_main_concern_this_message_is_priva+"\n"+Localization.shared.forgot_our_customer_support_will_get_back_to_you_via_emai
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if #available(iOS 13.0, *) {
            messageTextField.overrideUserInterfaceStyle = .light
            titleTextField.overrideUserInterfaceStyle = .light 
        }
            
        containerView.addSubview(bottomContainerView)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: headerView, bottomContainerView)
        
        if bottomContainerView.isSmallScreenSize == true {
            containerView.addConstraintsWithFormat(format: "H:|-(>=0,==0@900)-[v0(<=500)]-(>=0,==0@900)-|", views: bottomContainerView)
        } else {
            containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: bottomContainerView)
        }
        NSLayoutConstraint(item: bottomContainerView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        setupContainerView()
        addSendButton()
        
    }
    
    func setupContainerView() {
                
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 20))
        titleTextField.heightAnchor.constraint(equalToConstant: 54).isActive = true
        titleTextField.font = titleTextField.font?.withSize(view.getCorrectSize(15, 15, 20))
        messageTextField.font = messageTextField.font?.withSize(view.getCorrectSize(15, 15, 20))
        
        bottomContainerView.addSubview(titleLabel)
        bottomContainerView.addSubview(messageLabel)
        bottomContainerView.addSubview(titleTextField)
        bottomContainerView.addSubview(messageTextField)
        bottomContainerView.addSubview(explainerLabel)
        bottomContainerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: titleLabel)
        bottomContainerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: messageLabel)
        bottomContainerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: titleTextField)
        bottomContainerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: messageTextField)
        bottomContainerView.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: explainerLabel)

        bottomContainerView.addConstraintsWithFormat(format: "V:|-50-[v0(20)]-10-[v1]-20-[v2(20)]-10-[v3]-10-[v4]", views: titleLabel, titleTextField, messageLabel, messageTextField, explainerLabel)
    }
    
    func addSendButton() {
        let sendButton = PlanButton(title: Localization.shared.send, image: nil, backgroundColor: UIColor(named: "emailUsSendButtonBgColor")!, textColor: .white)
        sendButton.titleLabel?.font = sendButton.titleLabel?.font.withSize(view.getCorrectSize(15, 15, 21))
        sendButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(54, 55, 70)).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
        bottomContainerView.addSubview(sendButton)
        
        let guide = self.bottomContainerView.safeAreaLayoutGuide
        sendButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: getBottomSafeAreaHeight() == 0 ? view.getCorrectSize(-20, -40, -50) : 0).isActive = true
        if bottomContainerView.isSmallScreenSize == true {
            bottomContainerView.addConstraintsWithFormat(format: "H:|-(>=30,==30@900)-[v0(<=500)]-(>=30,==30@900)-|", views: sendButton)
        } else {
            bottomContainerView.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: sendButton)
        }
        bottomContainerView.addConstraintsWithFormat(format: "V:[v0]-50-[v1]", views: explainerLabel, sendButton)
        NSLayoutConstraint(item: sendButton, attribute: .centerX, relatedBy: .equal, toItem: bottomContainerView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    @objc func sendButtonAction() {
        
        if ((titleTextField.text?.count ?? 0) == 0) || (messageTextField.text.count == 0) { presentDataPopup(withString: Localization.shared.email_us_fill_all_fields); return }
        
        if ((titleTextField.text!.count < 6) || (messageTextField.text.count < 6)) { presentDataPopup(withString: Localization.shared.message_is_short); return }
       
        sendContactRequest { (error, isTokenValid) in
            if error != nil {
                self.showFailPopup(title: Localization.shared.error, subtitle: Localization.shared.server_error, selector: #selector(self.closePopup(vc:)))
            } else {
                if isTokenValid == true {
                    self.dissmissViewAfterPopup = true
                    DispatchQueue.main.async {
                        self.showSuccessPopup(title: Localization.shared.forgot_message_sent_successfully_, subtitle: Localization.shared.forgot_our_customer_support_will_get_back_to_you_via_emai, selector: #selector(self.closeSuccessPopup))
                    }
                } else {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.sendButtonAction()
                        } else {
                            self.needToLogout = true
                            self.showFailPopup(title: Localization.shared.error, subtitle: Localization.shared.an_error_occured, selector: #selector(self.closePopup(vc:)))
                        }
                    })
                }
            }
        }
        
    }
    
    var needToLogout : Bool = false
    var dissmissViewAfterPopup : Bool = false
    
    @objc func closePopup(vc : CenterPopupViewController) {
        if self.needToLogout == true {
            self.presentLogoutDueToBadToken()
        } else if dissmissViewAfterPopup == true {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func closeSuccessPopup() { }
    
    func presentLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentDataPopup(withString message : String) {
        let popup = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        popup.view.tintColor = UIColor(named: "alertOkButtonTintColor")
        popup.addAction(UIAlertAction(title: Localization.shared.settings_ok.uppercased(), style: .default, handler: nil))
        self.present(popup, animated: true, completion: nil)
    }
    
    func sendContactRequest(completion: @escaping (Error?, Bool) -> ()) {
           
        guard let url = CyberExpertAPIEndpoint.contactForm.url() else { completion(NetworkError.invalidURL, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "message": messageTextField.text ?? "",
            "subject" : titleTextField.text ?? "",
            "phone_number" : UserData.shared.phone_number,
            "country_code" : UserData.shared.country_code,
            "name" : UserData.shared.firstName,
            "email" : UserData.shared.email
        ]
           
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
           
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
                
            if error != nil { completion(NetworkError.generic, false); return }

            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                            
                if let dataObj = json_object?["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, false); return }
                    }
                }
                
                if let status = json_object?["status"] as? Bool {
                    if status == false {
                        completion(NetworkError.generic, true)
                        return
                    }
                }
                
            }
            completion(nil, true)
        }
           
    }
}


class DefaultTextView: UITextView {
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        font = UIFont(name: "Muli-Regular", size: 15)
        translatesAutoresizingMaskIntoConstraints = false
        keyboardAppearance = .dark
        textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DefaultTextField: UITextField {
    
    init(placeholderText : String) {
        super.init(frame: .zero)
        placeholder = placeholderText
        font = UIFont(name: "Muli-Regular", size: 15)
        translatesAutoresizingMaskIntoConstraints = false
        keyboardAppearance = .dark
        textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        let leftImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 6))
        leftImageView.contentMode = .scaleAspectFit
        leftView = leftImageView
        leftViewMode = .always
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
