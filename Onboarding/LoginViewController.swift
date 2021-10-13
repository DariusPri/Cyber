//
//  LoginViewController.swift
//  Xpert
//
//  Created by Darius on 27/07/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import StoreKit

protocol NotLoggedInViewProtocol { }

struct RegistrationData {
    var first_name : String?
    var last_name : String?
    var email : String?
    var password : String?
    var phone_number : String?
    var plan_uuid : String?
    var countryCode : String?
    
    init() {
        first_name = nil; last_name = nil; email = nil; password = nil; phone_number = nil; plan_uuid = nil; countryCode = nil
    }
}
class XpertNavigationController : UINavigationController {
    var registrationData : RegistrationData?
}

class LoginViewController: NavViewController, ErrorPresenter, NotLoggedInViewProtocol {
    
    // MARK:- Init
    
    var emailInputField : SquareTextView?
    var passwordInputField : SquareTextView?
    
    let signInButton = SquareButton(title:Localization.shared.new_to_dynarisk.doubleBracketReplace(with: "DYNARISK").uppercased()+" "+Localization.shared.sign_up.uppercased(), image: nil, backgroundColor: UIColor.secondaryButtonColor, textColor: .defaultTextColor)
    var header : HeaderLabel?
    let forgotPasswordButton = TextButton(title: Localization.shared.forgot_password.uppercased())
    let signUpButton = SquareButton(title: Localization.shared.sign_in.uppercased(), image: nil, backgroundColor: UIColor(named: "primaryButtonColor")!, textColor: UIColor(named: "primaryButtonTextColor")!)

    
    init() {
        super.init(leftButton: nil, rightButton: nil, title: Localization.shared.sign_in_to_dynarisk.doubleBracketReplace(with: "Dynarisk"), subtitle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
    
        titleLabel.textColor = UIColor(named: "defaultTextColor")

        setupSignUpButton()
        
        setupSignInButtonStyle()
        
        setupEmailInputField()
        
        setupPasswordField()

        setupMainStack()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    // MARK:- Setup UI
    
    func setupSignUpButton() {
        signUpButton.setTitleColor(UIColor(named: "primaryButtonTextColor"), for: .normal)
        signUpButton.backgroundColor = UIColor.init(named: "primaryButtonColor")
        signUpButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 15)
        signUpButton.addTarget(self, action: #selector(dashboardVC), for: .touchUpInside)
        signUpButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupSignInButtonStyle() {
        signInButton.backgroundColor = UIColor.init(named: "secondaryButtonColor")
        signInButton.setTitleColor(UIColor(named: "secondaryButtonTextColor"), for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Muli-Regular", size: 15)
        signInButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        view.addSubview(signInButton)
        signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: signInButton)
        view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: signInButton)
        NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupHeader() -> HeaderLabel {
        let header = HeaderLabel(text: Localization.shared.login_enter_login_information, edgeInsets : view.isSmallScreenSize == true ? UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0) : .zero, textSize: view.getCorrectSize(26, 26, 34))
        self.header = header
        self.header?.textColor = UIColor(named: "defaultTextColor")
        if view.isSmallScreenSize == false { header.textAlignment = .center }
        return header
    }
    
    func setupPasswordView() -> UIView {
        forgotPasswordButton.setTitleColor(UIColor(named: "defaultTextColor"), for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        let passwordContainerView = UIView()
        passwordContainerView.addSubview(forgotPasswordButton)
        passwordContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: forgotPasswordButton)
        passwordContainerView.addConstraintsWithFormat(format: "H:|[v0]", views: forgotPasswordButton)
        return passwordContainerView
    }
    
    func setupMainStack() {
        
        let header = setupHeader()
        
        _ = [header, emailInputField!, passwordInputField!, setupPasswordView(), signUpButton].map({ mainStack.addArrangedSubview($0) })
        mainStack.axis = .vertical
        mainStack.spacing = 14
        mainStack.setCustomSpacing(view.getCorrectSize(24, 24, 36), after: header)

        view.addSubview(mainStack)
        view.addConstraintsWithFormat(format: "H:|-(>=20,==20@900)-[v0(<=500)]-(>=20,==20@900)-|", views: mainStack)
        NSLayoutConstraint(item: mainStack, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: mainStack, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    }
    
    func setupEmailInputField() {
        emailInputField = SquareTextView(placeholderText: Localization.shared.email_address)
        emailInputField!.textField.keyboardType = .emailAddress
        emailInputField!.translatesAutoresizingMaskIntoConstraints = false
        emailInputField!.heightAnchor.constraint(equalToConstant: 54).isActive = true
        emailInputField!.textField.font = emailInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        emailInputField!.placeholderLabel.font = emailInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
    }
    
    func setupPasswordField() {
        passwordInputField = SquareTextView(placeholderText: Localization.shared.password)
        passwordInputField!.translatesAutoresizingMaskIntoConstraints = false
        passwordInputField!.heightAnchor.constraint(equalToConstant: 54).isActive = true
        passwordInputField!.textField.font = passwordInputField!.textField.font?.withSize(view.getCorrectSize(15, 15, 20))
        passwordInputField!.placeholderLabel.font = passwordInputField!.textField.font?.withSize(view.getCorrectSize(13, 13, 18))
        passwordInputField!.textField.isSecureTextEntry = true
        if #available(iOS 12.0, *) {
            passwordInputField!.textField.passwordRules = UITextInputPasswordRules(descriptor: "")
        }
    }
    
    
    // MARK:- Login Logic

    var results : Any?
    
    func checkForValidReceipt() {
    
        print("check for valid receipt!", IAPManager.shared.products?.count ?? 0)
        
        var products : [SKProduct] = []
        let now = Date()
        
        func stopLoading() {
            self.loginButton(isEnabled: true)
            self.loadingScreen(enabled: false)
        }

        func getNextProduct() {
            print("profuct count:", products.count)
            guard let product = products.popLast() else { print("hellow there!"); stopLoading(); self.presentPlanSelectionViewController(); return }
              proceedWith(product: product)
          }
        
        func proceedWith(product : SKProduct) {
            
            print("checking product ! :", product.localizedTitle)
            
            let data = IAPManager.shared.expirationDateFor(product.productIdentifier)
            
            guard let endDate = data.endDate, let transactionId = data.originalTransactionId, endDate > now else { getNextProduct(); print("no producst?P("); return }
                        
            IAPPaidPlansCollectionViewController.getUserForTransactionId(transactionId: transactionId) { (email, errors) in
                if errors.count > 0 {
                    stopLoading()
                    //self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                    self.presentPlanSelectionViewController()
                    return
                }
                
                if email == "" { self.presentPlanSelectionViewController(); return }
                                
                if let email = email, (self.emailInputField?.textField.text ?? "").lowercased() != email.lowercased() {
                    self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.apple_id_has_plan_enabled.doubleBracketReplace(with: email)]))
                    stopLoading()
                    return
                }
                
                PaidPlansViewController.getPlansRequest { (paidPlans, success) in

                    if success == false {
                        stopLoading()
                        self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                        return
                    }
                    
                    let name = product.productIdentifier.split(separator: ".")[1].lowercased()
                    guard let plan = paidPlans.first(where: { $0.type.stringForIdentifier() == name }) else {
                        stopLoading()
                        self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.error_occured]))
                        return
                    }
                    
                    let couponCode = IAPPaidPlansCollectionViewController.getCouponFor(product: product)
                    
                    CouponNavViewController.check(with: couponCode) { (data, errorString) in

                        if errorString != nil {
                            stopLoading()
                            self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error+" \(errorString ?? "")"]))
                            return
                        }
                        
                        PaidPlansCollectionViewController.selectPlan(paidPlanUuid: plan.uuid) { (success) in

                            if success == false {
                                stopLoading()
                                self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                                return
                            }
                            
                            IAPPaidPlansCollectionViewController.setSubscriptionEndDate(withEndate: endDate, transactonId: transactionId) { (success) in

                                if success == false {
                                    stopLoading()
                                    self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                                    return
                                }
                                self.dashboardVC()
                                return
                            }
                        }
                    }
                }
                
            }
            
        }
        
        func startLoadingWithProducts() {
            IAPManager.shared.refreshSubscriptionsStatus(callback: {
                guard let productArray = IAPManager.shared.products else { return }
                products = productArray
                getNextProduct()
            }) { (error) in
                stopLoading()
                if let error = error {
                    self.presentError(viewModel: ErrorViewModel(errorText: ["\(Localization.shared.error_occured). \(error.localizedDescription)"]))
                } else {
                    self.presentPlanSelectionViewController()
                }
            }
        }
        
        if IAPManager.shared.products?.count ?? 0 == 0 {
            print("4", IAPManager.shared.products?.count)
            IAPManager.shared.loadProducts() {
                print("3")
                if (IAPManager.shared.products?.count ?? 0) == 0 {
                    stopLoading()
                    self.presentError(viewModel: ErrorViewModel(errorText: ["Failed to load App Store Products"]))
                } else {
                    print("2")
                    startLoadingWithProducts()
                }
            }
        } else {
            print("1")
            startLoadingWithProducts()
        }
  

    }
    
    var loadingView : DimmedBgLoadingView?
    
    func loadingScreen(enabled : Bool) {
        guard let nav = self.navigationController?.view else { return }
        DispatchQueue.main.async {
            if enabled == true {
                if self.loadingView != nil { return }
                self.loadingView = DimmedBgLoadingView(frame: nav.bounds)
                nav.addSubview(self.loadingView!)
            } else {
                self.loadingView?.removeFromSuperview()
                self.loadingView = nil
            }
        }
    }
    
    func presentPlanSelectionViewController() {
        print("present plan selection? ")
        DispatchQueue.main.async {
            self.loadingScreen(enabled: false)
            let paidPlansVC = IAPPaidPlansViewController()
            let nac = XpertNavigationController(rootViewController: paidPlansVC)
            self.navigationController?.present(nac, animated: true, completion: nil)
        }
    }
  
    
    func scansNeeded() -> Bool {
        let currentUuid = UserData.shared.user_uuid
        let savedUuid = UserData.shared.localUserData.lastUsedAccountUuid
        return currentUuid != savedUuid
    }
    
    func setupDeviceAssessment(for scanFinishedVC : inout FinishedAssessmentViewController) {
        scanFinishedVC.bottomInfoButton.setTitle(Localization.shared.loading_assessment+"..", for: .normal)
        let beginVC = BeginAssessmentViewController()
        beginVC.detailedView.subheaderLabel.text = Localization.shared.device_assessment_subheader
        scanFinishedVC.nextViewController = beginVC
    }
    
    func proceedToDashboard() {
        self.loadingScreen(enabled: false)
        let dashVC = DashboardTabBarController()
        dashVC.dashboardVC.dashboardCollectionViewController.collectionView.reloadData()
        self.navigationController?.setViewControllers([dashVC], animated: true)
    }
    
    func proceedForNextStep() {
        let isAssessmentDone = UserData.shared.localUserData.isAssessmentDone ?? false
        
        if scansNeeded() == true {
            let scanVC = ScanViewController(isTrial: false, initView: false)
            var doneScanVC = FinishedAssessmentViewController()
            doneScanVC.detailedView.subheaderLabel.text = Localization.shared.scans_scans_have_finished_all_tasks_please_wait_as_you_w
            scanVC.scanResultsVC = doneScanVC

            func setViewControllers() {
                self.loadingScreen(enabled: false)
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([scanVC], animated: true)
                }
            }
            if isAssessmentDone == true {
                self.getDeviceAssessmentForCurrentDevice { (deviceAssessmentNeeded, errorArray) in
                    if deviceAssessmentNeeded == true {
                        self.setupDeviceAssessment(for: &doneScanVC)
                        setViewControllers()
                        return
                    } else {
                        self.proceedToDashboard()
                        return
                    }
                }
            } else {
                self.setupDeviceAssessment(for: &doneScanVC)
                setViewControllers()
            }
            
        } else {
            if isAssessmentDone == true {
                self.getDeviceAssessmentForCurrentDevice { (deviceAssessmentNeeded, errorArray) in
                    if let errorStringArray = errorArray, errorStringArray.count > 0 {
                        self.loadingScreen(enabled: false)
                        self.loginButton(isEnabled: true)
                        self.presentError(viewModel: ErrorViewModel(errorText: errorStringArray))
                        return
                    }
                    DispatchQueue.main.async {
                        if deviceAssessmentNeeded == true {
                            self.loadingScreen(enabled: false)
                            let beginVC = BeginAssessmentViewController()
                            beginVC.detailedView.subheaderLabel.text = Localization.shared.device_assessment_subheader
                            self.navigationController?.setViewControllers([beginVC], animated: true)
                        } else {
                            self.proceedToDashboard()
                            return
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingScreen(enabled: false)
                    let beginVC = BeginAssessmentViewController()
                    self.navigationController?.setViewControllers([beginVC], animated: true)
                }
            }
        }
    }
    
    func loginButton(isEnabled : Bool) {
        DispatchQueue.main.async {
            self.signUpButton.isEnabled = isEnabled
        }
    }
    
    @objc func dashboardVC() {
        var errors : [String] = []
        if emailInputField?.textField.text == "" { errors.append(Localization.shared.login_email_address_field_is_empty_) }
        if passwordInputField?.textField.text == "" { errors.append(Localization.shared.login_password_field_is_empty_) }
        presentError(viewModel: ErrorViewModel(errorText: errors.count == 0 ? nil : errors))
        if errors.count != 0 { self.loginButton(isEnabled: true); self.loadingScreen(enabled: false); return }
        
        self.loginButton(isEnabled: false)
        self.loadingScreen(enabled: true)
        
        func updateTokenAndProceed() {
            SharedRequestStore.shared.updateUserToken(completion: { (success) in
                if success == false {
                    self.loginButton(isEnabled: true)
                    self.loadingScreen(enabled: false)
                    self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                    return
                }
                
                self.setCurrentSoftware { (success, errorStringArray) in
                    if success == false {
                        self.loginButton(isEnabled: true)
                        self.loadingScreen(enabled: false)
                        self.presentError(viewModel: ErrorViewModel(errorText: errorStringArray))
                        return
                    }
                    self.proceedForNextStep()
                }
            })
        }
        
        fetchLogin { (errorStrings) in
            if let errorStringArray = errorStrings, errorStringArray.count > 0 {
                self.loginButton(isEnabled: true)
                self.loadingScreen(enabled: false)
                self.presentError(viewModel: ErrorViewModel(errorText: errorStringArray))
                return
            }
            
            self.getCurrentUser { (errorList, hasDeviceSet) in
                
                print("get current user!")
                if let errorStringArray = errorList, errorStringArray.count > 0 {
                    self.loginButton(isEnabled: true)
                    self.loadingScreen(enabled: false)
                    self.presentError(viewModel: ErrorViewModel(errorText: errorStringArray))
                    return
                }
                
                if UserData.shared.currentPlan.status == false {
                    print("current plan status false :(")
                    DispatchQueue.main.async {
                        self.checkForValidReceipt()
                    }
                    return
                }
            
                self.getUserDevices { (success, hasDeviceSet) in
                    
                    print("get user devices!")

                    if success == false {
                        self.loginButton(isEnabled: true)
                        self.loadingScreen(enabled: false)
                        self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error]))
                        return
                    }
                    
                    if hasDeviceSet == false {
                        self.setCurrentDevice { (success, errorString)  in
                            
                            print("set current user devices!")

                            if success == false {
                                self.loginButton(isEnabled: true)
                                self.loadingScreen(enabled: false)
                                self.presentError(viewModel: ErrorViewModel(errorText: [errorString ?? Localization.shared.login_errror_occured_while_saving_new_device_please_try_]));
                                return
                            }
                            updateTokenAndProceed()
                            return
                        }
                    } else {
                        updateTokenAndProceed()
                    }
                }
            }
        }
    }
    
    @objc func signUp() {
        (self.navigationController as! XpertNavigationController).registrationData = RegistrationData()
        (self.navigationController as! XpertNavigationController).registrationData?.email = "test@tes.com"
        self.navigationController?.pushViewController(OnboardingViewController(), animated: true)
    }
    
    @objc func forgotPassword() {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
    
    func check(model : String) -> String {
         if ["iPod touch", "iPhone", "iPhone Simulator"].contains(model) == true { return "phone" }
         else if ["iPad", "iPad Simulator"].contains(model) == true { return "tablet" }
         return "phone"
     }
    
    func fetchLogin(completion: @escaping ([String]?) -> ()) {
        guard let url = CyberExpertAPIEndpoint.auth.url() else { completion(["Something went wrong. Please try again"]); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        emailInputField?.textField.text = emailInputField?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        passwordInputField?.textField.text = passwordInputField?.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) 
        
        UserData.shared.username = emailInputField?.textField.text?.lowercased() ?? ""
        UserData.shared.password = passwordInputField?.textField.text?.lowercased() ?? ""
        UserData.shared.fingerprint = UIDevice.current.identifierForVendor!.uuidString.sha512
        UserData.shared.scan_by = "app"
        UserData.shared.device_type = check(model: UIDevice.current.model)
        
        let parameters: [String: Any] = [
            "email": emailInputField?.textField.text?.lowercased() ?? "",
            "password": passwordInputField?.textField.text ?? "",
            "device_type" : check(model: UIDevice.current.model),
            "fingerprint" : UIDevice.current.identifierForVendor!.uuidString.sha512,
            "scan_by" : "app"
        ]
                
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())

        NetworkClient.shared.sendRequest(needAuth: false, request: request) { (data, response, error) in
            guard let data = data else { completion([Localization.shared.an_error_occured]); return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let token = json["auth"] as? String, let refreshToken = json["refresh_token"] as? String {
                        UserData.shared.localUserData.token = token
                        UserData.shared.localUserData.refreshToken = refreshToken
                        
                        print("DATA :", json)
                        
                        if let settings = json["settings"] as? [String : Any] {
                            if let profiles = settings["profile"] as? [[String : Any]] {
                                for profile in profiles {
                                    if profile["key"] as? String == "flag.assessment.shown" {
                                        UserData.shared.localUserData.isAssessmentDone = (profile["value"] as? Bool) ?? false
                                    } else if profile["key"] as? String == "flag.user_tour.shown" {
                                        UserData.shared.localUserData.isUserTourDone = (profile["value"] as? Bool) ?? false
                                    }
                                }
                            }
                        }
                        
                        if let isPlanSelected = json["is_plan_selected"] as? Int, isPlanSelected != 1 {
                            DispatchQueue.main.async {
                                self.checkForValidReceipt()
                            }
                            return
                        }
                        print("ALL GOOD!")
                        completion(nil)
                        return
                    } else {
                        if let errors = json["errors"] as? [String : Any] {
                            var errorArray : [String] = []
                            
                            errors.forEach({ (data) in
                                if let errorString = (data.value as? [String : Any])?["rule"] as? String {
                                    errorArray.append(errorString)
                                }
                            })
                            completion(errorArray)
                            return
                        }
                    }
                }
            } catch {
                completion([Localization.shared.server_error])
                return
            }
            completion([Localization.shared.error_occured])
        }
    }
    
    static func getModelCode() -> String? {
        var systemInfo = utsname()
         uname(&systemInfo)
         let modelCode = withUnsafePointer(to: &systemInfo.machine) {
             $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                 ptr in String.init(validatingUTF8: ptr)

             }
         }
        return modelCode
    }
        
    func setCurrentSoftware(completion: @escaping (Bool, [String]?) -> ()) {
        guard let url = CyberExpertAPIEndpoint.currentSoftware.url() else { completion(false, [Localization.shared.server_error]); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        
        let webView = WKWebView()
        var secretAgent: String? = nil
        var browserVersion : String?
        
        func doRequest() {
        
            if let agent = secretAgent {
                let versionList = agent.components(separatedBy: "AppleWebKit/")
                if versionList.count > 1 {
                    let version = versionList[1].components(separatedBy: " ")
                    if version.count > 0 { browserVersion = version[0] }
                }
            }
        
            var parameters : [String : Any] = ["slug" : "IOS", "build" : UIDevice.current.systemVersion, "version" : UIDevice.current.systemVersion]
            if let model = LoginViewController.getModelCode() { parameters["model"] = model }
            
            var data = ["slug" : "SAFARI"] as [String : String]

            if let browser = browserVersion {
                data["version"] = browser
            } else {
                data["version"] = "1.0"
            }
        
            parameters["browsers"] = [data]
                        
            if #available(iOS 13.0, *) {
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
            } else {
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            }
            
            NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, _) in
                if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                    if let errorData = json?["error"] as? [String : Any] {
                        let errorMessage = errorData["message"] as? String
                        completion(false, [errorMessage ?? Localization.shared.server_error])
                        return
                    }
                    completion(true, nil)
                    return
                }
                completion(true, nil)
            }
        }
        
        webView.evaluateJavaScript("navigator.userAgent") { (string, error) in
            if let agent = string as? String {
                secretAgent = agent
            }
            doRequest()
        }
               
     }
    
    func getDeviceAssessmentForCurrentDevice(completion: @escaping (Bool, [String]?) -> ()) {
        let uuid = UserData.shared.currentDeviceUuid
        guard let url = CyberExpertAPIEndpoint.getDeviceAssessment(uuid).url() else { completion(false, [Localization.shared.server_error]); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, _) in
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                if let percentage = json?["percentage_done"] as? Double {
                    completion(percentage != 100, [])
                    return
                }
            }
            completion(false, [Localization.shared.server_error])
        }
    }
    
    func getUserDevices(completion: @escaping (Bool, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.getDevices.url() else { completion(false, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"

        let fingerprint = UIDevice.current.identifierForVendor!.uuidString.sha512
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            if error != nil { completion(false, false); return }
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                if let items = json?["items"] as? [[String : Any]] {
                    for item in items {
                        if let finger = item["fingerprint"] as? String {
                            if finger == fingerprint {
                                if let uuid = item["uuid"] as? String {
                                    UserData.shared.currentDeviceUuid = uuid
                                }
                                completion(true, true)
                                return
                            }
                        }
                    }
                }
            } else { completion(false, false); return }
            completion(true, false)
        }
    }

    
    func getCurrentUser(completion: @escaping ([String]?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.getCurrentUser.url() else { completion([Localization.shared.server_error], true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            guard let data = data else { completion([Localization.shared.server_error], true); return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if let allData = json["user"] as? [String : Any] {
                        
                        if let profile = allData["profile"] as? [String : Any], let hasActivePlan = profile["has_active_plan"] as? Bool, hasActivePlan == false {
                            UserData.shared.currentPlan.status = false
                            completion(nil, true)
                            return
                        }

                        if let userData = allData["user"] as? [String : Any] {
                            if let email = userData["email"] as? String {
                                UserData.shared.email = email.lowercased()
                            }
                            
                            if let phone_number = userData["phone_number"] as? String {
                                UserData.shared.phone_number = phone_number
                            }
                            
                            if let country_code = userData["country_code"] as? String {
                                UserData.shared.country_code = country_code
                            }
                            
                            if let name = userData["first_name"] as? String {
                                UserData.shared.firstName = name
                            }
                            
                            if let lastName = userData["last_name"] as? String {
                                UserData.shared.lastName = lastName
                            }
                            
                            if let uuid = userData["uuid"] as? String {
                                UserData.shared.user_uuid = uuid
                            }
                            
                            if let planData = allData["plan"] as? [String : Any] {
                                if let uuid = planData["uuid"] as? String, let name = planData["name"] as? String, let slug = planData["slug"] as? String, let type = planData["type"] as? String, let status = planData["is_active"] as? Bool, let planValidTo = allData["plan_valid_to"] as? Int {
                                        let currentPlanData = PlanData(uuid: uuid, name: name, slug: slug, type: type, status: status, endDate : planValidTo)
                                        UserData.shared.currentPlan = currentPlanData
                                }
                            }
                            
                            completion(nil, true)
                            return
                        }
                    }

                } else {

                }
            } catch {}
            completion([Localization.shared.server_error], true)
        }
    }
    
    func setCurrentDevice(completion: @escaping (Bool, String?) -> ()) {
        guard let url = CyberExpertAPIEndpoint.addNewDevice.url() else { completion(false, nil); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
  
        let parameters: [String: Any] = [
            "name" : UIDevice.current.name,
            "fingerprint" : UIDevice.current.identifierForVendor!.uuidString.sha512,
            "scan_by" : "app",
            "device_type" : check(model: UIDevice.current.model),
            "auto_activate":true,
            "os" : "ios"
        ]
                
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            guard let data = data else { completion(false, nil); return }
                                    
            if let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                if let status = json?["status"] as? Bool, status == false {
                    let message = (json?["data"] as? [String : Any])?["message"] as? String
                    completion(false, message)
                } else {
                    if let uuid = json?["uuid"] as? String {
                        UserData.shared.currentDeviceUuid = uuid
                    }
                    completion(true, nil)
                }
            } else {
                completion(false, nil)
            }
        }
    }
}
