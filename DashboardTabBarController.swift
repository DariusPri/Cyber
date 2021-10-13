//
//  DashboardTabBarController.swift
//  Xpert
//
//  Created by Darius on 14/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

final class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let dashboardVC = DashboardViewController()
    let emailsVC = DataViewController()
    let devicesVC = DevicesViewController()
    let todoVC = ToDoViewController()
    let supportVC = SupportViewController()


    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
        self.tabBar.tintColor = UIColor(named: "defaultTextColor")
        self.tabBar.isTranslucent = false

        let tabViewControllers = [devicesVC, emailsVC, dashboardVC, todoVC, supportVC]
        viewControllers = tabViewControllers
        self.selectedIndex = tabViewControllers.firstIndex(of: dashboardVC) ?? 0

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        setTabBarIcons()
        resetIfNeeded()
        
        patchSoftware { (_) in
            self.getSoftwareChecks { (_) in
                //
            }
        }
        
    }
    
    @objc func appMovedToForeground() { }

    @objc func presentSettings() {
        let settingsVC = SettngsViewController()
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        (viewController as? UserSelectableTab)?.userDidSelectTab()
        if let vc = viewController as? NavViewController {
            let tabViewControllers = [devicesVC, emailsVC, dashboardVC, todoVC, supportVC]
            let unselectedVCs : [NavViewController] = tabViewControllers.filter({ $0 != vc })
            for unselectedVC in unselectedVCs {
                (unselectedVC as? UserSelectableTab)?.tabDeselected()
            }
        }
        
    }
    
    
    
    func setTabBarIcons() {
        let unselectedIcons = [#imageLiteral(resourceName: "devices_unselected_ic"), #imageLiteral(resourceName: "data_unselected_ic"), #imageLiteral(resourceName: "dashboard_unselected_ic"), #imageLiteral(resourceName: "todo_unselected_ic"), #imageLiteral(resourceName: "suport_unselected_ic")]
        let selectedIcons = [#imageLiteral(resourceName: "devices_selected_ic"), #imageLiteral(resourceName: "data_selected_ic"), #imageLiteral(resourceName: "dashboard_selected_ic"), #imageLiteral(resourceName: "todo_selected_ic"), #imageLiteral(resourceName: "suport_selected_ic")]
        let tabViewControllers = [devicesVC, emailsVC, dashboardVC, todoVC, supportVC]
        let viewControllerNames = [Localization.shared.devices, Localization.shared.menu_data, Localization.shared.dashboard, Localization.shared.to_do, Localization.shared.menu_support]
        
        for (i, vc) in tabViewControllers.enumerated() {
            vc.tabBarItem = UITabBarItem(title: viewControllerNames[i], image: unselectedIcons[i], selectedImage: selectedIcons[i])
            vc.rightButton?.addTarget(self, action: #selector(presentSettings), for: .touchUpInside)
        }
    }
    
    
    func resetIfNeeded() {
        if #available(iOS 13.0, *) {
            self.traitCollection.performAsCurrent {
                self.tabBar.tintColor = UIColor(named: "defaultTextColor")
                self.tabBar.unselectedItemTintColor = UIColor(named: "unselectedItemTextColor")
                self.tabBar.barTintColor = UIColor(named: "tabBarTintColor")
                self.tabBar.layer.borderColor = UIColor(named: "tabBarBorderColor")?.cgColor
                setTabBarIcons()
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
            resetIfNeeded()
        }
    }
    
    func patchSoftware(completion : @escaping ((Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.currentSoftware.url() else { completion(false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "PATCH"
            
        let hardwareEncryption : [String : Any] = ["slug" : "ROOT_ACCESS", "value" : DashboardCollectionViewController.canWriteSystemFiles() == true ? "1" : "0"]
        let screenLock : [String : Any] = ["slug" : "SCREEN_LOCK", "value" : DashboardCollectionViewController.screenLockEnabled() == true ? "1" : "0"]
        let settingsData : [Any] = [hardwareEncryption, screenLock]
        var parameters : [String : Any] = ["slug" : "IOS", "version" : UIDevice.current.systemVersion, "settings" : settingsData]
        if let model = LoginViewController.getModelCode() { parameters["model"] = model }

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())

            
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            
            guard let data = data else { completion(false); return }
            
            do {
                let _  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                    completion(true)
                    return
               } catch {}
               completion(true)
           }
       }
    
    func getSoftwareChecks(completion : @escaping ((Bool)->())) {
        
        guard let url = CyberExpertAPIEndpoint.softwareChecks(UserData.shared.currentDeviceUuid).url() else { completion(false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
                   
        NetworkClient.shared.sendRequest(needAuth: true, request: request, completion: { (data, _, error) in
            
            guard let data = data else { completion(false); return }

            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
                if let items = json_object["items"] as? [[String : Any]] {
                    for item in items {
                        if item["user_device_uuid"] as? String == UserData.shared.currentDeviceUuid, let slug = item["slug"] as? String {
                            for (i, data) in self.dashboardVC.dashboardCollectionViewController.taskActions.enumerated() {
                                if slug == data.taskActionSlug.taskActionSlug.rawValue {
                                    if let generatedSlug = item["generated_action_slug"] as? String, let counter = item["counter_issues"] as? Int, counter > 0 {
                                        self.dashboardVC.dashboardCollectionViewController.taskActions[i].taskActionSlug.value = generatedSlug
                                    }
                                }
                            }
                        }
                    }
                    
                    self.dashboardVC.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        self.dashboardVC.dashboardCollectionViewController.collectionView.reloadSections(IndexSet(integer: 1))
                    }, completion: nil)
                }
            } catch {}
            completion(true)
        })
    }
  
}

protocol UserSelectableTab {
    func userDidSelectTab()
    func tabDeselected()
}
