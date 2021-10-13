//
//  AppDelegate.swift
//  Xpert
//
//  Created by Darius on 05/06/2018.
//  Copyright © 2018 Dynarisk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var userData : UserData = UserData()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        IAPManager.shared.startWith(arrayOfIds: AppStoreData.arrayOfProductIds, sharedSecret: AppStoreData.secret)

        configureFirebase()
        registerFirebaseNotifications(application)
        Messaging.messaging().delegate = self
        
        let loadingView = LoadingViewController()

        var counter = 0
        func checkForDone() {
            counter += 1
            if counter == 2 {
                let mainViewController = XpertNavigationController(rootViewController: LoginViewController())
                self.window?.rootViewController = mainViewController
            }
        }
        
        Localization.shared.getCurrentLanguage { (success) in
            checkForDone()
        }
        
        loadingView.animate {
            checkForDone()
        }
        
        window?.rootViewController = loadingView
        window?.makeKeyAndVisible()
        return true
    }
    
    func configureFirebase() {
        var filePath : String?
        if CyberExpertAPI.isProduction == true {
            filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        } else {
            filePath = Bundle.main.path(forResource: "GoogleService-Info-staging", ofType: "plist")!
        }
        guard let path = filePath else { return }
        let options = FirebaseOptions(contentsOfFile: path)
        FirebaseApp.configure(options: options!)
    }
    
    func registerFirebaseNotifications(_ application : UIApplication) {
        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
    
    var shortcutItemToProcess : UIApplicationShortcutItem?
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Alternatively, a shortcut item may be passed in through this delegate method if the app was
        // still in memory when the Home screen quick action was used. Again, store it for processing.
        shortcutItemToProcess = shortcutItem
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    //    vc = window?.rootViewController
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    var loadingVC : DimmedBgLoadingView?
    
    func stopLoadingAndLogout(withErrorMessage error : String?) {
        DispatchQueue.main.async {
            self.loadingVC?.removeFromSuperview()
            DashboardViewController.logOutUserDueToBadToken()
            let loginVC = (self.window?.rootViewController as? UINavigationController)?.viewControllers.first as? LoginViewController
            if let error = error {
                loginVC?.presentError(viewModel: ErrorViewModel(errorText: [error]))
            }
        }
    }
    
    func addloader(vc : UIViewController) {
        if let loadingVC = loadingVC {
            loadingVC.removeFromSuperview()
            self.loadingVC = nil
        }
        
        loadingVC = DimmedBgLoadingView(frame: vc.view.bounds)
        vc.view.addSubview(loadingVC!)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        setCompletionBlocksForExtendedSubscription()
        
        guard let vc = (window!.rootViewController as? UINavigationController)?.viewControllers.last else { return }
        if vc is NotLoggedInViewProtocol { return }
        
        addloader(vc: vc)
        
        SharedRequestStore.shared.updateUserToken(completion: { (success) in
            if success == false {
                self.stopLoadingAndLogout(withErrorMessage: Localization.shared.an_error_occured)
                return
            }

            let now = Date()

            if let endDate = UserData.shared.currentPlan.endDate, Date(timeIntervalSince1970: TimeInterval(endDate)) > now {
                self.loadingVC?.removeFromSuperview()
                self.loadingVC = nil
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+10) {
                    if IAPManager.shared.isRestoreAvailable() == false {
                        self.stopLoadingAndLogout(withErrorMessage: "Your subscription has passed. Please login and select a new plan")
                    }
                }
           }
       })
    }
    
    func setCompletionBlocksForExtendedSubscription() {
        IAPManager.shared.updateTransactionsCompletionBlock = {
            
            
            if IAPManager.shared.isRestoreAvailable() == true {

                let now = Date()

                guard let productArray = IAPManager.shared.products, let productToUpdate = productArray.first(where: { if let date = IAPManager.shared.expirationDateFor($0.productIdentifier).endDate { return date > now}; return false }) else {
                    self.stopLoadingAndLogout(withErrorMessage: Localization.shared.an_error_occured);
                    return
                }

                let data = IAPManager.shared.expirationDateFor(productToUpdate.productIdentifier)
                guard let transactionId = data.originalTransactionId, let endDate = data.endDate else {
                    self.stopLoadingAndLogout(withErrorMessage: Localization.shared.an_error_occured);
                    return
                }

                IAPPaidPlansCollectionViewController.getUserForTransactionId(transactionId: transactionId) { (email, errors) in

                    if errors.count > 0 {
                        self.stopLoadingAndLogout(withErrorMessage: Localization.shared.server_error);
                        return
                    }

                    let savedUserEmail = UserData.shared.email

                    if let email = email, savedUserEmail.lowercased() != email.lowercased() {
                        self.stopLoadingAndLogout(withErrorMessage: Localization.shared.apple_id_has_plan_enabled.doubleBracketReplace(with: email))
                        return
                    }

                    PaidPlansViewController.getPlansRequest { (paidPlans, success) in

                        if success == false {
                            self.stopLoadingAndLogout(withErrorMessage: Localization.shared.server_error);
                            return
                        }

                        let name = productToUpdate.productIdentifier.split(separator: ".")[1].lowercased()

                        guard let plan = paidPlans.first(where: { $0.type.stringForIdentifier() == name }) else {
                            self.stopLoadingAndLogout(withErrorMessage: Localization.shared.an_error_occured);
                            return
                        }

                        let couponCode = IAPPaidPlansCollectionViewController.getCouponFor(product: productToUpdate)


                        CouponNavViewController.check(with: couponCode) { (data, errorString) in

                            if errorString != nil {
                                self.stopLoadingAndLogout(withErrorMessage: Localization.shared.server_error);
                                return
                            }

                            PaidPlansCollectionViewController.selectPlan(paidPlanUuid: plan.uuid) { (success) in

                                if success == false {
                                    self.stopLoadingAndLogout(withErrorMessage: Localization.shared.server_error);
                                    return
                                }

                                IAPPaidPlansCollectionViewController.setSubscriptionEndDate(withEndate: endDate, transactonId: transactionId) { (success) in

                                    if success == false {
                                        self.stopLoadingAndLogout(withErrorMessage: Localization.shared.server_error);
                                        return
                                    }

                                    UserData.shared.currentPlan.endDate = Int(endDate.timeIntervalSince1970)
                                    UserData.shared.currentPlan.uuid = plan.uuid
                                    UserData.shared.currentPlan.name = plan.type.rawValue

                                    self.loadingVC?.removeFromSuperview()
                                    self.loadingVC = nil
                                    return
                                }
                            }
                        }
                    }
                }

            } else {
                self.stopLoadingAndLogout(withErrorMessage: Localization.shared.passed_plan)
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let shortcutItem = shortcutItemToProcess {
            
            guard let dashboardVC = (window?.rootViewController as? UINavigationController)?.viewControllers.first as? DashboardTabBarController else { return }
            
            if shortcutItem.type == "hacked" {
                dashboardVC.supportVC.supportCollectionViewController.takeActionFor(index: 1)
            } else if shortcutItem.type == "faq" {
                dashboardVC.supportVC.supportCollectionViewController.takeActionFor(index: 0)
            }
            
            shortcutItemToProcess = nil
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        IAPManager.shared.removeObserver()
    }

}


extension AppDelegate : UNUserNotificationCenterDelegate, MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //
    }
}
