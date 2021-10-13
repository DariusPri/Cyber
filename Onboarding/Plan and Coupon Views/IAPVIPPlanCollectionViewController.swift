//
//  IAPVIPPlanCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 2020-03-02.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import StoreKit

class IAPVIPPlanCollectionViewController : VIPPlanCollectionViewController {
    
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
                self.shopSuccessPopup(title: Localization.shared.plan_restored, subtitle: sentence1+". "+sentence2)
            }
        }
    }
    
    override func setupButtonTitle() {
        
        planButton?.alpha = 1
                
        if paidPlanData.isBoughtPlan == true {
            planButton?.setTitle(Localization.shared.your_plan.uppercased(), for: .normal)
            planButton?.isEnabled = false
        } else {
            
            let now = Int(Date().timeIntervalSince1970)
            let currentPlanEndDate = UserData.shared.currentPlan.endDate ?? now
            
            if IAPManager.shared.isRestoreAvailable() == true || currentPlanEndDate > now {
                planButton?.isEnabled = false
                planButton?.alpha = 0
            } else {
                planButton?.isEnabled = true
                planButton?.setTitle( Localization.shared.upgrade_plane_standard_select_plan.uppercased(), for: .normal)
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
                
                self.shopSuccessPopup(title: Localization.shared.popup_coupon_plan_subtitle, subtitle: Localization.shared.plan_status_success.doubleBracketReplace(with: self.paidPlanData.type.rawValue)+". "+Localization.shared.plan_will_renew_on_date.doubleBracketReplace(with: endDate!.userLocaleReadableString()) )
                
            }
        }
        
    }
}
