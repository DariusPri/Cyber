//
//  PersonalInfoViewController.swift
//  Xpert
//
//  Created by Darius on 2020-01-15.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class PersonalInfoViewController : TextInputViewController {
    
    init() {
        let data = [TextInputCollectionViewController.TextInputData(inputType: .firstName, placeholder: Localization.shared.first_name+"...", value: UserData.shared.firstName, isOptional: false, isEnabled: true),
                    TextInputCollectionViewController.TextInputData(inputType: .lastName, placeholder: Localization.shared.last_name+"...", value: UserData.shared.lastName, isOptional: false, isEnabled: true),
                    TextInputCollectionViewController.TextInputData(inputType: .email, placeholder: Localization.shared.email_address+"...", value: UserData.shared.email, isOptional: false, isEnabled: false)
                    //TextInputCollectionViewController.TextInputData(inputType: .recoveryEmail, placeholder: Localization.shared.email_address+"...", value: "", isOptional: true, isEnabled: true)]
                    ]
        super.init(data: data)
        headerLabel.text = Localization.shared.personal_information
        textInputCompletionData = { data in
                        
            var tokenRequestAlreadyMade = false
            func updateToken() {
                tokenRequestAlreadyMade = true
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        updateInfo()
                    } else {
                        self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.an_error_occured]))
                    }
                })
            }
            
            func saveLocalData() {
                for d in data {
                    switch d.inputType {
                    case .firstName:
                        UserData.shared.firstName = d.value
                    case .lastName:
                        UserData.shared.lastName = d.value
                    case .email:
                        UserData.shared.email = d.value
                    //case .recoveryEmail:
                    //    UserData.shared.recoveryEmail = d.value
                    default:
                       break
                    }
                }
            }
            
            func updateInfo() {
                self.updatePersonalInfo(personalDatas: data, completion: { (errorList, isTokenExpired) in
                    if isTokenExpired == true {
                        if tokenRequestAlreadyMade == true {
                            self.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.an_error_occured]))
                        } else {
                            updateToken()
                        }
                    }
                    if let errors = errorList {
                        self.presentError(viewModel: ErrorViewModel(errorText: errors))
                    } else {
                        saveLocalData()
                        self.presentError(viewModel: ErrorViewModel(errorText: nil))
                        DispatchQueue.main.async {
                            self.presentSuccessfulCenterPopup(withIcon: UIImage(named: "donecheck_ill_dark"), andTitle: Localization.shared.success.capitalized, andSubtitle: Localization.shared.personal_info_changed)
                            (((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as? XpertNavigationController)?.viewControllers.last as? SettngsViewController)?.settingsCollectionViewController.collectionView.reloadData()
                        }
                    }
                })
            }
            updateInfo()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
    }
        
    func updatePersonalInfo(personalDatas: [TextInputCollectionViewController.TextInputData], completion: @escaping ([String]?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.personalEdit.url() else { return completion([Localization.shared.an_error_occured], false) }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "first_name":  personalDatas[0].value,
            "last_name":  personalDatas[1].value,
            "email":  personalDatas[2].value
           // "recovery_email" : personalDatas[3].value
        ]
                
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(nil, false)
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                completion(nil, true)
            } else {
                var errorList : [String] = []
                if let data = data, let json_object = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                    if let errors = json_object?["errors"] as? [String : Any] {
                        for (k, _) in errors {
                            for (_ ,v) in (errors[k] as? [String : Any] ?? [:]) {
                                if let errorString = v as? String {
                                    errorList.append(errorString)
                                }
                            }
                        }
                    }
                }
                completion(errorList.count == 0 ? [Localization.shared.error_occured] : errorList, false)
            }
        }
    }
    
}





