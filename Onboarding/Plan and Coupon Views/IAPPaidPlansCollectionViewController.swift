//
//  IAPPaidPlansCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 2020-03-02.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import StoreKit


class IAPPaidPlansCollectionViewController : PaidPlansCollectionViewController {
 
    func setupRestoreButton() {
        guard let nav = nav.items?.first else { return }
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "couponNavLeftButtonTextColor")!,
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        let rightButtonAttributesDisabled : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "couponNavLeftButtonTextColor")!.withAlphaComponent(0.5),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        nav.rightBarButtonItem = UIBarButtonItem(title: Localization.shared.restore.uppercased(), style: .plain, target: self, action: #selector(restorePurchases(sender:)))
        nav.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        nav.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .highlighted)
        nav.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributesDisabled, for: .disabled)
    }
    
    @objc func restorePurchases(sender : UIBarButtonItem) {
        sender.isEnabled = false
        
        IAPPaidPlansCollectionViewController.restorePurchasesActionRequest(paidPlanData: self.paidPlanData) { (success, error, endDate) in
            sender.isEnabled = true
            
            if success == false  || error != nil {
                self.presentSimpleOKError(withTitle: error ?? Localization.shared.error_occured, andSubtitle: "", completion: {})
                return
            }
            
            if let endDate = endDate, success == true {
                
                IAPPaidPlansCollectionViewController.setPlanData(with: self.paidPlanData, endDate: endDate)
                
                let sentence1 = Localization.shared.plan_status_success.doubleBracketReplace(with: self.paidPlanData.type.rawValue)
                let sentence2 = Localization.shared.plan_will_renew_on_date.doubleBracketReplace(with: endDate.userLocaleReadableString())
                self.shopSuccessPopup(title: Localization.shared.plan_restored.capitalized, subtitle: sentence1+". "+sentence2)
            }
        }
    }
    
    static func setPlanData(with plan : PaidPlan, endDate : Date) {
        
        UserData.shared.currentPlan.name = plan.type.stringForIdentifier().capitalized
        UserData.shared.currentPlan.endDate = Int(endDate.timeIntervalSince1970)
        UserData.shared.currentPlan.uuid = plan.uuid
        
        if let settingsVC = ((UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? XpertNavigationController)?.viewControllers.last as? SettngsViewController {
            settingsVC.settingsCollectionViewController.collectionView.reloadData()
        }
    }
    
    static func restorePurchasesActionRequest(paidPlanData : PaidPlan, completion : @escaping ((Bool?, String?, Date?)->()) ) {
        
        
        func restorePurchases(product: SKProduct, expiration: Date, transactionId: String) {
            CouponNavViewController.check(with: IAPPaidPlansCollectionViewController.getCouponFor(product: product)) { (data, errorString) in

                if errorString != nil {
                    completion(false, Localization.shared.server_error+". "+(errorString ?? Localization.shared.coupon_not_applied), nil)
                    return
                }

                PaidPlansCollectionViewController.selectPlan(paidPlanUuid: paidPlanData.uuid) { (success) in

                    if success == false {
                        completion(false, Localization.shared.can_t_select_plan, nil)
                        return
                    }

                    IAPPaidPlansCollectionViewController.setSubscriptionEndDate(withEndate: expiration, transactonId: transactionId) { (success) in

                        if success == false {
                            completion(false, Localization.shared.server_error+". "+Localization.shared.can_t_select_plan, nil)
                            return
                        }

                        completion(true, nil, expiration)
                        return

                    }
                }
            }
        }
        
        IAPManager.shared.refreshSubscriptionsStatus(callback: {
                
            let now = Date()
            
            guard let identifier = paidPlanData.appStoreIdentifier, let expiration = IAPManager.shared.expirationDateFor(identifier).endDate, let transactionId = IAPManager.shared.expirationDateFor(identifier).originalTransactionId, let product = IAPManager.shared.products?.first(where: { $0.productIdentifier == identifier }),  expiration > now else { completion(false, Localization.shared.restore_not_available, nil); return }

            IAPPaidPlansCollectionViewController.getUserForTransactionId(transactionId: transactionId) { (email, errors) in

                if errors.count > 0 {
                    let errorString = errors.joined(separator: ". ")
                    completion(false, Localization.shared.server_error+". "+errorString, nil);
                    return
                }
                     
                let savedUserEmail = UserData.shared.email

                if let email = email, savedUserEmail.lowercased() != email.lowercased() {
                    completion(false, Localization.shared.apple_id_has_plan_enabled.doubleBracketReplace(with: email), nil);
                    return
                } else {
                    restorePurchases(product: product, expiration: expiration, transactionId: transactionId)
                }
            }
            
        }) { (error) in
            
            if let error = error as? SKError {
                if error.code != .paymentCancelled {
                    completion(false, Localization.shared.server_error+". "+error.localizedDescription, nil)
                }
                return
            }
            completion(false, Localization.shared.restore_not_available, nil)
        }
        
    }
    
    override func setupButtonTitle() {
        
        planButton?.alpha = 1
                
        if paidPlanData.isBoughtPlan == true {
            planButton?.setTitle(Localization.shared.your_plan.uppercased(), for: .normal)
            planButton?.isEnabled = false
        } else {
            planButton?.isEnabled = true
            
            let now = Int(Date().timeIntervalSince1970)
            let currentPlanEndDate = UserData.shared.currentPlan.endDate ?? now

            if IAPManager.shared.isRestoreAvailable() == true || currentPlanEndDate > now {
                planButton?.setTitle(Localization.shared.change_plan.uppercased(), for: .normal)
            } else {
                planButton?.setTitle(Localization.shared.upgrade_plane_standard_select_plan.uppercased(), for: .normal)
            }
        }
        setupRestoreButton()
    }
    
    override func changePlanAction() {
        
        planButton?.isEnabled = false
        
        IAPPaidPlansCollectionViewController.changePlanActionRequest(paidPlanData: paidPlanData) { (success, error, endDate) in
            
            self.planButton?.isEnabled = true

            if let success = success {
                
                if success == false || endDate == nil {
                    self.presentSimpleOKError(withTitle: error ?? Localization.shared.error_occured, andSubtitle: "", completion: {})
                    return
                }
                
                IAPPaidPlansCollectionViewController.setPlanData(with: self.paidPlanData, endDate: endDate!)
                
                let popup = self.getPopupFor(title: Localization.shared.popup_coupon_plan_subtitle, subtitle: Localization.shared.plan_status_success.doubleBracketReplace(with: self.paidPlanData.type.rawValue)+". "+Localization.shared.plan_will_renew_on_date.doubleBracketReplace(with: endDate!.userLocaleReadableString()) )
                self.navigationController!.present(popup, animated: true, completion: nil)
                
            }
        }
    }
    
    static func changePlanActionRequest(paidPlanData : PaidPlan, completion : @escaping ((Bool?, String?, Date?)->())) {
        
        if let product = IAPManager.shared.getProductForIdentifier(identifier: paidPlanData.appStoreIdentifier) {
            IAPManager.shared.purchaseProduct(product: product, success: {
                let couponCode = IAPPaidPlansCollectionViewController.getCouponFor(product: product)
                let data = IAPManager.shared.expirationDateFor(product.productIdentifier)
                guard let endDate = data.endDate, let transactionId = data.originalTransactionId, couponCode != "" else { completion(false, Localization.shared.error_occured, nil); return }
                                                
                CouponNavViewController.check(with: couponCode) { (data, errorString) in
                    if errorString != nil {
                        completion(false, Localization.shared.server_error+". "+(errorString ?? Localization.shared.coupon_not_applied), nil)
                        return
                    }
                    
                    PaidPlansCollectionViewController.selectPlan(paidPlanUuid: paidPlanData.uuid) { (success) in
                        
                        if success == false {
                            completion(false, Localization.shared.can_t_select_plan, nil)
                            return
                        }
                        
                        IAPPaidPlansCollectionViewController.setSubscriptionEndDate(withEndate: endDate, transactonId: transactionId) { (success) in
                            if success == false {
                                completion(false, Localization.shared.server_error+". "+Localization.shared.can_t_select_plan, nil)
                                return
                            }
                            completion(true, nil, endDate)
                        }
                    }
                }

            }) { (error) in
                                
                guard let error = error as? SKError else { completion(nil, nil, nil); return }
                
                switch error.code {
                case .paymentCancelled:
                    completion(nil, nil, nil);
                    return
                case .unauthorizedRequestData:
                    completion(false, "Unauthorised Error", nil)
                    return
                case .paymentNotAllowed:
                    completion(false, "Payment not allowed", nil)
                    return
                default:
                    completion(false, Localization.shared.server_error+". "+error.localizedDescription, nil)
                }
                
            }
        } else {
            completion(false, nil, nil)
        }
    }
    
    static func getUserForTransactionId(transactionId : String, completion: @escaping ((String?, [String])->())) {
        guard let url = CyberExpertAPIEndpoint.getUserByTransactionId(transactionId).url() else { completion(nil, [Localization.shared.server_error]); return }
        var request = URLRequest.jsonRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            print("url: ", url.absoluteString)
            print("get users for transaction id: ", String(data: data!, encoding: .utf8))
            
            if let data = data, let json = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??) {
                
                if let email = json?["email"] as? String {
                    if let datas = json?["user_profiles"] as? [[String : Any]], let data = datas.first, let hasActivePlan = data["has_active_plan"] as? Int, hasActivePlan == 1 {
                        completion(email.lowercased(), [])
                        return
                    } else {
                        completion(nil, [])
                        return 
                    }
                } else if let status = json?["status"] as? Bool, status == false {
                    completion("", [])
                    return 
                }
            }
            completion(nil, [Localization.shared.server_error])
        }
    }
    
    static func setSubscriptionEndDate(withEndate date: Date, transactonId : String, completion : @escaping ((Bool)->())) {
        
        guard let url = CyberExpertAPIEndpoint.planExpireDate.url() else { completion(false); return  }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
         
        let parameters: [String: Any] = [
            "valid_to": Int(date.timeIntervalSince1970),
            "transaction_id" : transactonId
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
         
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            if error != nil || data == nil { completion(false); return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any], let status = json["status"] as? Bool {
                    completion(status)
                    return
                }
            } catch {
                completion(false)
                return
            }
            completion(false)
        }
        
    }
    
    static func getCouponFor(product : SKProduct) -> String {
        var couponCode = ""
        
        if CyberExpertAPI.isProduction == true {
            switch product.productIdentifier {
            case "dynarisk.Advantage":
                couponCode = "iosbbadvantage"
            case "dynarisk.Ultimate":
                couponCode = "iosuu2ultimate"
            case "dynarisk.Standard":
                couponCode = "iosqqqstandart"
            default:
                couponCode = ""
            }
        } else {
            couponCode = "FULL"
        }
        
        return couponCode
    }
    
}


extension Date {
    func userLocaleReadableString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
}
