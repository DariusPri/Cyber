//
//  AssessmentBaseViewController.swift
//  Xpert
//
//  Created by Darius on 03/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class BaseAssessmentViewController : NavViewController, ErrorPresenter {
        
    var headerTextView : HeaderTextView?
    var headerLabel : HeaderLabel?
    let iconDetailView = IconDetailView(icon: #imageLiteral(resourceName: "lock_ic"), text: Localization.shared.assessment_footer, margins : UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), lineSpacing : 0.5)
    let questionContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.textInputBorderColor.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }()
    
    let questionCounterButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Muli-Regular", size: 13)
        button.setTitleColor(UIColor(named: "AssessmentQuestionCounterTextColor")!, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        button.alpha = 0 // not visible
        return button
    }()
    
    let loadingView = LoadingBakcgroundView()
    
    // MARK:- Init
    
    var percentage : Double = 0
    var assessmentData : AssessmentData?
    var assessmentTableHeightConstraint : NSLayoutConstraint?
    let assessmentTableViewController = AssessmentTableViewController()
    
    var titleWidthConstraint : NSLayoutConstraint?
    
    let backButton = BackNavButton()

    init() {
        if UIScreen.main.bounds.size.width > 500 {
            super.init(leftButton: backButton, rightButton: nil, title: " ", subtitle: nil)
            titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            titleStack.addArrangedSubview(questionCounterButton)
            titleStack.spacing = 0
        } else { super.init(leftButton: backButton, rightButton: questionCounterButton, title: " ", subtitle: nil) }
        backButton.addTarget(self, action: #selector(backButton(sender:)), for: .touchUpInside)
    }
    
    @objc func backButton(sender : UIButton) {
        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            let count = self.navigationController!.viewControllers.count
            if let baseAssessmentVC = self.navigationController?.viewControllers[count-2] as? BaseAssessmentViewController {
                baseAssessmentVC.assessmentTableViewController.tableView.isUserInteractionEnabled = true
            }
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        assessmentTableHeightConstraint?.constant = assessmentTableViewController.tableView.contentSize.height
        if UIScreen.main.bounds.size.width > 500 {
            titleLabel.sizeToFit()
            titleLabel.layoutIfNeeded()
            titleWidthConstraint?.constant = titleLabel.bounds.size.width
        } else {
            titleWidthConstraint?.constant = customNavBar.bounds.size.width - backButton.bounds.size.width - questionCounterButton.bounds.size.width - 80
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        addLoadingView()
        getData()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 100)
        titleWidthConstraint?.isActive = true
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: loadingView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        loadingView.startAnimating()
    }
    
    func getData() {}
    func answerWith(indexes indexArray : [Int]) {}
    func finishAssessmentAction() {}
    
    func setup() {
        
        guard let assessmentData = self.assessmentData else { return }
        
        self.loadingView.stopAnimating()
        
        self.headerTextView = HeaderTextView(text: assessmentData.questionDatas[assessmentData.questionIndex].questionText, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), lineSpacing: 1)
        self.headerTextView!.addExplainer(for: assessmentData.questionDatas[assessmentData.questionIndex].explainers)
        self.headerLabel = HeaderLabel(text: assessmentData.questionDatas[assessmentData.questionIndex].questionText, edgeInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15), lineSpacing: 1)
        self.assessmentTableViewController.assessmentType = assessmentData.questionDatas[assessmentData.questionIndex].type
        self.assessmentTableViewController.assessmentAnswers = assessmentData.questionDatas[assessmentData.questionIndex].answers
        self.questionCounterButton.setTitle("\(Int(self.percentage)) %", for: .normal)

        self.questionCounterButton.titleLabel?.font = self.questionCounterButton.titleLabel?.font.withSize(self.view.getCorrectSize(13, 13, 16))
        self.headerLabel!.font = self.headerLabel!.font.withSize(self.view.getCorrectSize(26, 26, 32))
        self.titleLabel.font = self.titleLabel.font.withSize(self.view.getCorrectSize(20, 20, 26))
        
        self.headerTextView!.delegate = self
                
        if assessmentData.questionDatas[assessmentData.questionIndex].type == .singleSelect {
            self.assessmentTableViewController.singleSelectCompletion = { index in
                self.assessmentData!.questionDatas[self.assessmentData!.questionIndex].answers[index].isSelected = true
                self.answerWith(indexes: [index])
            }
        } else {
            self.assessmentTableViewController.multipleSelectCompletion = { indexArray in
                if indexArray.count == 0 { self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.assessment_you_must_select_at_least_one])); return }
                self.presentError(viewModel: ErrorViewModel(errorText: nil))
                self.assessmentData!.questionIndex += 1
                self.answerWith(indexes: indexArray)
            }
        }
        self.addChild(self.assessmentTableViewController)
        self.questionContainerView.addSubview(self.assessmentTableViewController.view)
        self.questionContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: self.assessmentTableViewController.view)
        self.questionContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: self.assessmentTableViewController.view)
        self.assessmentTableHeightConstraint = self.questionContainerView.heightAnchor.constraint(equalToConstant: 100)
        self.assessmentTableHeightConstraint?.isActive = true
        
        _ = [self.headerTextView!, self.questionContainerView, self.iconDetailView].map({ self.mainStack.addArrangedSubview($0) })
        self.mainStack.axis = .vertical
        self.mainStack.spacing = 14
        self.mainStack.setCustomSpacing(self.view.getCorrectSize(24, 24, 32), after: self.headerTextView!)
        self.mainStack.setCustomSpacing(24, after: self.questionContainerView)
        
        self.mainScrollView.addSubview(self.mainStack)
        self.mainScrollView.addConstraintsWithFormat(format: "H:|-(>=15,==15@900)-[v0(<=\(self.view.getCorrectSize(512, 512, 700)))]-(>=15,==15@900)-|", views: self.mainStack)
        NSLayoutConstraint(item: self.mainStack, attribute: .top, relatedBy: .equal, toItem: self.mainScrollView, attribute: .top, multiplier: 1, constant: self.view.getCorrectSize(44, 44, 102)).isActive = true
        NSLayoutConstraint(item: self.mainStack, attribute: .bottom, relatedBy: .equal, toItem: self.mainScrollView, attribute: .bottom, multiplier: 1, constant: -100).isActive = true
        NSLayoutConstraint(item: self.mainStack, attribute: .centerX, relatedBy: .equal, toItem: self.mainScrollView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        self.headerTextView!.sizeToFit()
        self.headerTextView!.layoutIfNeeded()
        
    }
}



extension BaseAssessmentViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let explainerIndex = Int(URL.lastPathComponent), let nav = self.navigationController else { return false }
        
        let beginning = textView.beginningOfDocument
        let start = textView.position(from: beginning, offset: characterRange.location)
        let end = textView.position(from: start!, offset: characterRange.length)
        let textRange = textView.textRange(from: start!, to: end!)
        let rect = textView.firstRect(for: textRange!)
        let convertedRect = textView.convert(rect, to: nav.view)
        
        let data = TutorialViewController.TutorialCardData.init(title: "", subtitle: assessmentData!.questionDatas[assessmentData!.questionIndex].explainers[explainerIndex].explanation, highlightFrames: [convertedRect], arrowView: nil)
        let vc = ExplainerViewController(forTextExplainer: data, rect: convertedRect, present: nav)
        self.navigationController?.present(vc, animated: true, completion: nil)
        
        return false
    }
}












class AssessmentBaseViewController: BaseAssessmentViewController {
    
    override func getData() {
        
        let isAssessmentDone = UserData.shared.localUserData.isAssessmentDone ?? false
        let uuid = UserData.shared.currentDeviceUuid
        
        func finishAssessment() {
            DispatchQueue.main.async {
                self.finishAssessmentAction()
                return
            }
        }

        if isAssessmentDone == false {
            getAssessmentData { (data, percentage, isTokenValid, hasErrorOccured) in
                if percentage == 100 {
                    finishAssessment()
                } else {
                    if isTokenValid == false {
                        SharedRequestStore.shared.updateUserToken(completion: { (success) in
                            if success == true {
                                self.getData()
                            } else {
                                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                                    DashboardViewController.logOutUserDueToBadToken()
                                }
                            }
                        })
                        return
                    } else if hasErrorOccured == true {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {
                            _ = DashboardViewController.logoutUserWithoutError()
                        })
                    } else {
                        self.titleLabel.text = Localization.shared.assessment_assessing_your_risk
                        self.assessmentData = data
                        self.percentage = percentage
                        self.setup()
                    }
                }
            }
        } else {
            if uuid.count != 0 {
                self.currentDeviceAssessmentIfNeeded(uuid: uuid) { (percentage) in
                    if percentage == 100 { finishAssessment(); return }
                }
            }
        }
    }
    
    func currentDeviceAssessmentIfNeeded(uuid : String, completion : @escaping (Double)->()) {
        DispatchQueue.main.async {
            self.titleLabel.text = Localization.shared.device_assessment
        }
        DeviceAssessmentViewController.getAssessmentData(uuid: uuid) { (assessmentData, percentage, isTokenValid, hasErrorOccured) in
            
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.currentDeviceAssessmentIfNeeded(uuid: uuid, completion: completion)
                    } else {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                            DashboardViewController.logOutUserDueToBadToken()
                        }
                    }
                })
                return
            } else if hasErrorOccured == true {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {
                    _ = DashboardViewController.logoutUserWithoutError()
                })
            } else {
                DispatchQueue.main.async {
                    completion(percentage)
                    self.assessmentData = assessmentData
                    self.percentage = percentage
                    self.setup()
                }
            }
        }
    }
    
    
    func getAssessmentData(completion : @escaping ((AssessmentData?, Double, Bool, Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.getGeneralAssessment.url() else { return completion(nil, 0, true, true) }
        print("URL :", url.absoluteString)
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, 0, true, true); return }
            
            do {
                if let json  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    
                    print("GET DATA :", json)
                    
                    let sessionUuid = json["session_uuid"] as? String ?? ""
                    var questionDataArray : [AssessmentQuestionData] = []
                                        
                    if let questionDatas = json["question"] as? [String : Any] {
                        let questionTitle = questionDatas["title"] as? String ?? ""
                        let type = questionDatas["type"] as? String ?? ""
                        let questionUuid = questionDatas["uuid"] as? String ?? ""
                        var answerDataArray : [AssessmentAnswer] = []
                        let explainers : [(word : String, explanation : String)] = [] // not used for version 1.0
                        
                        let cancelsOutAnswers : Bool = questionDatas["alias"] as? String ?? "" == "Q006"
                        
                        if let answerDatas = questionDatas["answer_variants"] as? [[String : Any]] {
                            for answerData in answerDatas {
                                let answerText = answerData["value"] as? String ?? ""
                                let answerUuid = answerData["uuid"] as? String ?? ""
                                answerDataArray.append(AssessmentAnswer.init(text: answerText, isSelected: false, rightImage: nil, answerUuid: answerUuid, cancelsOutOtherAnswers: cancelsOutAnswers == true && answerData["alias"] as? String ?? "" == "A6"))
                            }
                        }
                        questionDataArray.append(AssessmentQuestionData(type: AssessmentType(text: type), questionText: questionTitle, answers: answerDataArray, explainers: explainers, questionUuid: questionUuid))
                    } else {
                        
                        print("GET DATA2 :", json)

                        if let dataObj = json["data"] as? [String : Any] {
                            if let name =  dataObj["code"] as? Int {
                                if name == 401 {
                                    completion(nil, 0, false, false)
                                    return
                                }
                            }
                        }
                         
                        if let status = json["status"] as? Bool, status == false {
                            completion(nil, 0, true, true)
                            return
                        }
                        
                        completion(nil, 100, true, false)
                        return 
                    }
                    let assessmentData : AssessmentData = AssessmentData(questionIndex: 0, sessionUuid: sessionUuid, questionDatas: questionDataArray)
                    let assessmentPercentage : Double = json["percentage_done"] as? Double ?? 0.0
                    completion(assessmentData, assessmentPercentage, true, false)
                    return
                }
            } catch {
                completion(nil, 0, true, true)
                return
            }
    
            completion(nil, 0, true, true)
        }
        
    }
    
    func answerAssessmentQuestion(answerIndexArray : [Int], completion : @escaping ((Bool)->())) {
        
        guard let url = CyberExpertAPIEndpoint.answerAssessmentQuestion.url() else { completion(false); return }
        print("URL :", url.absoluteString)
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"

        guard let assessmentData = self.assessmentData else { return }
        
        var answerValues : [[String : String]] = [[:]]
        
        for i in answerIndexArray {
            print("III :", i)
            var answerData : [String : String] = [:]
            answerData["uuid"] = assessmentData.questionDatas[0].answers[i].answerUuid
            answerValues.append(answerData)
        }
        
        answerValues.removeAll(where: { $0.isEmpty })

        let parameters: [String: Any] = [
            "session_uuid": assessmentData.sessionUuid,
            "question_uuid": assessmentData.questionDatas.first!.questionUuid,
            "values": answerValues
        ]
        
        print("ANSWER UUID :", parameters)
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
                        
            let dat = String(data: data!, encoding: .utf8)
            print("DAT :", dat)
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                print("POST DATA :", json)
                if let errorList = json["errors"] as? [String : Any], errorList.count > 0 {
                    print("ERROR LIST:", errorList, errorList.count)
                    completion(false)
                    ((UIApplication.shared.delegate as? AppDelegate)!.window!.rootViewController! as? UINavigationController)?.setViewControllers([LoginViewController()], animated: false)
                    return
                }
            }

            
            completion(error == nil ? true : false)
        }
    }
    


    override func finishAssessmentAction() {
        
        func presendDone() {
            DispatchQueue.main.async {
               let doneVC = FinishedAssessmentViewController()
               self.navigationController?.pushViewController(doneVC, animated: true)
           }
        }
        
        if (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.isAssessmentDone != true {
            assessmentShownRequest { (success) in
                if success == true {
                    presendDone()
                } else {
                    self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {
                        _ = DashboardViewController.logoutUserWithoutError()
                    })
                }
            }
        } else {
           presendDone()
        }
    }
    
    override func answerWith(indexes indexArray : [Int]) {
        answerAssessmentQuestion(answerIndexArray: indexArray) { (success) in
            if success == true {
                self.navigationController?.pushViewController(AssessmentBaseViewController(), animated: true)
            }
        }
    }

    func assessmentShownRequest(completion : @escaping ((Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.userAssessmentShown.url() else { completion(false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "PATCH"
        
        let parameters: [String: Any] = ["value" : true]
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(false); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let isAssessmentShown = json_object["value"] as? Bool {
                    (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.isAssessmentDone = isAssessmentShown
                    completion(true)
                    return
                }
            } catch {}
            completion(false)
        }
    }
    
}

