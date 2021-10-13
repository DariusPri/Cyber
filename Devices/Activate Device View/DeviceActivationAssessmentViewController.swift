//
//  DeviceActivationAssessmentViewController.swift
//  Xpert
//
//  Created by Darius on 28/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class DeviceAssessmentViewController : BaseAssessmentViewController {
    
    let deviceData : DeviceData
    weak var counterLabel : UILabel?
    
    var presentNextQuestionCompletion : (()->())?
    var presentFinishedAssessmentCompletion : (()->())?
    
    init(deviceData : DeviceData) {
        self.deviceData = deviceData
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeCustomNavBar()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg")) 
    }
    
    override func getData() {
        DeviceAssessmentViewController.getAssessmentData(uuid: self.deviceData.uuid) { (data, percentage, isTokenValid, errorOccured) in
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.getData()
                    } else {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                            self.dismiss(animated: true, completion: nil)
                            DashboardViewController.logOutUserDueToBadToken()
                        }
                    }
                })
                return
            } else if errorOccured == true {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error, completion: {
                    self.dismiss(animated: true, completion: nil)
                    DashboardViewController.logOutUserDueToBadToken()
                })
            } else {
                self.counterLabel?.text = "\(Int(percentage)) %"
                if percentage == 100 {
                    DispatchQueue.main.async {
                        self.finishAssessmentAction()
                    }
                } else {
                    self.assessmentData = data
                    self.percentage = percentage
                    self.setup()
                }
            }
        }
    }
    
    override func answerWith(indexes indexArray: [Int]) {
        answerAssessmentQuestion(answerIndexArray: indexArray) { (success) in
            if success == true {
                self.presentNextQuestionCompletion?()
            }
        }
    }
        
    override func finishAssessmentAction() {
        self.presentFinishedAssessmentCompletion?()
    }
        
    
    static func getAssessmentData(uuid: String, completion : @escaping ((AssessmentData?, Double, Bool, Bool)->())) {
        
        guard let url = CyberExpertAPIEndpoint.getDeviceAssessment(uuid).url() else { completion(nil, 0, true, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in

            do {
                if let data = data, let json  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] {
                    
                    print("DATA DEVICE : ", json)
                      
                    let sessionUuid = json["session_uuid"] as? String ?? ""
                    var questionDataArray : [AssessmentQuestionData] = []
                                            
                    if let questionDatas = json["question"] as? [String : Any] {
                        let questionTitle = questionDatas["title"] as? String ?? ""
                        let type = questionDatas["type"] as? String ?? ""
                        let questionUuid = questionDatas["uuid"] as? String ?? ""
                        var answerDataArray : [AssessmentAnswer] = []
                        let explainers : [(word : String, explanation : String)] = [] // not implemented for version 1.0
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
                        
                        if let dataObj = json["data"] as? [String : Any] {
                            if let name =  dataObj["code"] as? Int {
                                if name == 401 {
                                    completion(nil, 0, false, false)
                                    return
                                }
                            }
                        }
                        
                        if let status = json["status"] as? Int, status == 0 { //as? Bool, status == false {
                            print("uh-oh :(")
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
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"

        guard let assessmentData = self.assessmentData else { return }
       
        var answerValues : [[String : String]] = [[:]]
       
        for i in answerIndexArray {
            var answerData : [String : String] = [:]
            answerData["uuid"] = assessmentData.questionDatas[0].answers[i].answerUuid
            answerValues.append(answerData)
        }

        let parameters: [String: Any] = [
            "session_uuid": assessmentData.sessionUuid,
            "question_uuid": assessmentData.questionDatas.first!.questionUuid,
            "values": answerValues
        ]
       
       
       request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
       
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            completion(error == nil ? true : false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
