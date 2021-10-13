//
//  DataAPIStore.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation



// MARK: - DataAPIStore

/// _DataAPIStore_ is a class responsible for fetching data
final class DataAPIStore {
    
}


// MARK: - DataStoreProtocol

extension DataAPIStore: DataStoreProtocol {
    
    /// Sends a email activation email
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id

    func sendActivationForEmail(with uuid: String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.resendActivationForEmail(uuid).url() else { completion(false, ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
         
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode == 422 {
                completion(false, ErrorViewModel.init(errorText: [Localization.shared.activation_link_error]), true)
                return
            }
            
            completion(true, nil, true)
        }
    }
    
    /// Sends a phone number activation email
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id

    func sendActivationForPhone(with uuid: String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        //
    }

    /// Sends a credit card activation email
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id

    func sendActivationForCredit(with uuid: String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        //

    }
    
    /// Creates a new email
    ///
    /// - parameter completion: The completion block
    /// - parameter email: new email address

    func addNewEmail(withEmailString email: String, andIsFamily isFamily: Bool,  completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.addNewEmail.url() else { completion(false, ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "protected_email" : email,
            "is_family": isFamily
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode == 422 {
                var errorList : [String] = []
                if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
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
                completion(false, ErrorViewModel.init(errorText: errorList.count == 0 ? [Localization.shared.add_phone_error] : errorList), false)
                return
            }
            
            completion(true, nil, true)
        }
    }
    
    /// Creates a new phone number
    ///
    /// - parameter completion: The completion block
    /// - parameter code: New phone code number
    /// - parameter phone: New phone number

    func addNewPhone(withPhoneStringh phone: String, andCountryCode code : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.addNewPhone.url() else { completion(false, ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "protected_phone_number" : phone,
            "country_code" : code
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode == 422 {
                var errorList : [String] = []
                if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
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
                completion(false, ErrorViewModel.init(errorText: errorList.count == 0 ? [Localization.shared.add_phone_error] : errorList), false)
                return
            }
            
            completion(true, nil, true)
        }
    }
    
    /// Creates a new credit card
    ///
    /// - parameter completion: The completion block
    /// - parameter card: New credit card number

    func addNewCreditCard(withCreditCardString card: String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.addNewCard.url() else { completion(false, ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "credit_card_number" : card
        ]
            
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode == 422 {
                var errorList : [String] = []
                if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
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
                completion(false, ErrorViewModel.init(errorText: errorList.count == 0 ? [Localization.shared.add_phone_error] : errorList), false)
                return
            }
            
            completion(true, nil, true)
        }
    }
    
    
    /// Fetches a list of emails
    ///
    /// - parameter completion: The completion block
    
    func fetchEmailData(completion: @escaping ([EmailData], ErrorViewModel?, Bool) -> ()){
        
        guard let url = CyberExpertAPIEndpoint.getEmails.url() else { completion([], ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if let data = data, let jsonDatas  = ((try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]) as [String : Any]??), let dataArray = jsonDatas?["data"] as? [[String : Any]] {
                                
                var datas : [EmailData] = []
                for json in dataArray {
                    if let email = json["email"] as? String, let isActive = json["is_active"] as? Int {
                        let uuid = json["uuid"] as? String
                        let isFamily = json["is_family"] as? Bool ?? false
                        datas.append(EmailData.init(uuid: uuid, email: email, isActive: isActive == 1, isFamily: isFamily))
                    }
                }
                completion(datas, nil, true)
                return
            } else if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion([], nil, false); return }
                }
            }
    
            completion([], nil, true)
        }
    }
    
    /// Fetches a list of credit card datas
    ///
    /// - parameter completion: The completion block
    
    func fetchCreditData(completion: @escaping ([CreditCardData], ErrorViewModel?, Bool) -> ()){
        
        guard let url = CyberExpertAPIEndpoint.getCards.url() else { completion([], ErrorViewModel.init(errorText: [Localization.shared.server_error]), false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            do {
                if let data = data, let jsonDatas  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any], let dataArray = jsonDatas["data"] as? [[String : Any]] {
                    
                    var datas : [CreditCardData] = []
                    
                    for json in dataArray {
                        if let card = json["number"] as? String,
                            let isActive = json["is_active"] as? Int {
                            let uuid = json["uuid"] as? String
                            datas.append(CreditCardData(uuid: uuid, name: card, isActive: isActive == 1))
                        }
                    }
                    completion(datas, nil, true)
                    return
                }
            } catch { }
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion([], nil, false); return }
                }
            }
            completion([], ErrorViewModel.init(errorText: [""]), true)
        }
    }
    
    /// Fetches a list of phone number datas
    ///
    /// - parameter completion: The completion block
    
    func fetchPhoneData(completion: @escaping ([PhoneData], ErrorViewModel?, Bool) -> ()){
        guard let url = CyberExpertAPIEndpoint.getPhones.url() else { completion([], ErrorViewModel.init(errorText: [Localization.shared.server_error]), true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            do {
                if let data = data, let jsonDatas  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any], let dataArray = jsonDatas["data"] as? [[String : Any]] {
                    
                    var datas : [PhoneData] = []
                    
                    for json in dataArray {
                        if let phone = json["phone_number"] as? String, let countryCode = json["country_code"] as? String,
                            let isActive = json["is_active"] as? Int {
                            let uuid = json["uuid"] as? String
                            datas.append(PhoneData.init(uuid: uuid, name: "+"+countryCode+" "+phone, isActive: isActive == 1))
                        }
                    }
                    completion(datas, nil, true)
                    return
                }
            } catch {}
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion([], nil, false); return }
                }
            }
            completion([], ErrorViewModel.init(errorText: [""]), true)
        }
    }
    
    
  
    /// Deletes an email
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id

    func deleteEmail(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        guard let url = CyberExpertAPIEndpoint.deleteEmail(uuid).url() else { completion(false, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "DELETE"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in

            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error == nil {
                completion(true, nil, true)
            } else if let _ = error {
                completion(false, ErrorViewModel.init(errorText: [Localization.shared.deleting_email_error]), true)
            }
            
            
        }
    }
    
    /// Deletes a phone number
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id
    
    func deletePhone(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        guard let url = CyberExpertAPIEndpoint.deletePhone(uuid).url() else { completion(false, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "DELETE"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error == nil {
                completion(true, nil, true)
            } else if let _ = error {
                completion(false, ErrorViewModel.init(errorText: [Localization.shared.deleting_phone_error]), true)
            }
        }
    }
    
    /// Deletes a credit card
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Data item's unique id

    func deleteCard(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        guard let url = CyberExpertAPIEndpoint.deleteCard(uuid).url() else { completion(false, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "DELETE"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if let json_object = ((try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error == nil {
                completion(true, nil, true)
            } else if let _ = error {
                completion(false, ErrorViewModel.init(errorText: [Localization.shared.deleting_credit_card_error]), true)
            }
        }
    }

}
