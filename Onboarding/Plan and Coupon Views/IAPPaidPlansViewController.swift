//
//  IAPPaidPlansViewController.swift
//  Xpert
//
//  Created by Darius on 2020-03-02.
//  Copyright © 2020. All rights reserved.
//

import Foundation

class IAPPaidPlansViewController: PaidPlansViewController, ErrorPresenter {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(productsFromAppStoreLoaded), name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
        IAPManager.shared.loadProducts {}
        IAPManager.shared.getProductsFailureBlock = { error in
            print("IAP 1")
            self.presentSimpleOKError(withTitle: Localization.shared.can_t_get_plans, andSubtitle: "") {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func getPlans(completion: @escaping (Error?) -> ()) {
        super.getPlans { (error) in
            if error != nil {
                print("IAP 2")
                self.presentSimpleOKError(withTitle: Localization.shared.can_t_get_plans, andSubtitle: "") {
                    self.dismiss(animated: true, completion: nil)
                }
                return 
            }
            self.planDataLoaded = true
            DispatchQueue.main.async {
                self.checkForDone()
            }
        }
    }
    
    var productsLoaded = false
    var planDataLoaded = false
    
    func checkForDone() {
        if productsLoaded != true || planDataLoaded != true { return }
        
        guard let products = IAPManager.shared.products else { return }
        
        var newPaidPlans : [PaidPlan] = []
        let now = Date()
        
        let savedPlanData = UserData.shared.currentPlan
        
        for product in products {
            let name = product.productIdentifier.split(separator: ".")[1].lowercased()
            if var plan = self.paidPlans.first(where: { $0.type.stringForIdentifier() == name }) {
                plan.pricePerMonth = product.price.dividing(by: NSDecimalNumber(value: 12)).doubleValue.round(to: 2)
                plan.pricePerYear = product.price.doubleValue.round(to: 2)
                plan.priceWithCoupon = nil
                plan.priceWithDiscount = nil
                plan.isAppStorePlan = true
                plan.appStoreIdentifier = product.productIdentifier
                if let savedEndDate = savedPlanData.endDate, savedEndDate > Int(now.timeIntervalSince1970) {
                    if savedPlanData.uuid == plan.uuid || plan.type.stringForIdentifier() == savedPlanData.name.lowercased() {
                        plan.isBoughtPlan = true
                    }
                } else {
                    plan.isBoughtPlan = false
                }
                newPaidPlans.append(plan)
            }
        }
        self.paidPlans = newPaidPlans.sorted(by: { (a, b) in (a.pricePerYear ?? 0) < (b.pricePerYear ?? 0) })
        DispatchQueue.main.async {
            self.setupPaidPlansViewController()
        }
    }
    
    @objc func productsFromAppStoreLoaded() {
        if (IAPManager.shared.products?.count ?? 0) > 0 {
            self.productsLoaded = true
        } else {
            print("IAP 3")
            self.presentSimpleOKError(withTitle: Localization.shared.server_error, andSubtitle: "") {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        checkForDone()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
