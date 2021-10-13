//
//  DashboardViewController.swift
//  Xpert
//
//  Created by Darius on 26/06/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK:- Cell Identifiers

let notificationCellIdentifier = "NOTIFICATION_CELL_IDENTIFIER"
let deviceCellIdentifier = "DEVICE_CELL_IDENTIFIER"
let scanCellIdentifier = "SCAN_CELL_IDENTIFIER"
let deviceStatusCellIdentifier = "DEVICE_STATUS_CELL_IDENTIFIER"
let securityScoreCellIdentifier = "SECURITY_SCORE_CELL_IDENTIFIER"
let sectionHeaderViewIdentifier = "SECTION_HEADER_IDENTIFIER"


final class DashboardViewController : NavViewController, ErrorPresenter {
    
    var lightThemeStatusBar : Bool = true
    override var preferredStatusBarStyle : UIStatusBarStyle { return lightThemeStatusBar == true ? .default : .lightContent }
    
    
    let dashboardCollectionViewController = DashboardCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        let settingsButton = UIButton(type: .custom)
        settingsButton.imageView!.contentMode = .scaleAspectFill
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        super.init(leftButton: nil, rightButton: settingsButton, title: Localization.shared.dashboard, subtitle: nil)
        settingsButton.heightAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: view.getCorrectSize(26, 26, 34)).isActive = true
        settingsButton.setImage(view.isHugeScreenSize == true ? #imageLiteral(resourceName: "settings ic_max") : #imageLiteral(resourceName: "settings_ic"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bg"))
        
        view.addSubview(dashboardCollectionViewController.view)
        addChild(dashboardCollectionViewController)
        dashboardCollectionViewController.didMove(toParent: self)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: dashboardCollectionViewController.view)
        NSLayoutConstraint(item: dashboardCollectionViewController.view!, attribute: .top, relatedBy: .equal, toItem: customNavBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dashboardCollectionViewController.view!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: dashboardCollectionViewController.view!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        updateDeviceDatas()
    }

    
    func showFirstTimeTutorialViewIfNeeded() {
        if (UIApplication.shared.delegate as! AppDelegate).userData.localUserData.isUserTourDone != true {
            let tutorialVC = TutorialViewController()
            tutorialVC.modalPresentationStyle = .custom
            self.navigationController?.present(tutorialVC, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFirstTimeTutorialViewIfNeeded()
    }
    
    
    func updateNotificationDeviceDataSectionIfNeeded() {
        if dashboardCollectionViewController.inactiveDevices.count == 0 {
            if let index = self.dashboardCollectionViewController.settingsTypes[0].firstIndex(of: .notification) {
                DispatchQueue.main.async {
                    self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        self.dashboardCollectionViewController.settingsTypes[0].remove(at: index)
                        self.dashboardCollectionViewController.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                    }, completion: nil)
                }
            }
        } else {
            if dashboardCollectionViewController.settingsTypes[0].contains(.notification) != true {
                DispatchQueue.main.async {
                    self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        self.dashboardCollectionViewController.settingsTypes[0].insert(.notification, at: 1)
                        self.dashboardCollectionViewController.collectionView.insertItems(at: [IndexPath(item: 1, section: 0)])
                    }) { (_) in
                        self.dashboardCollectionViewController.notificationCV?.collectionView.reloadData()
                    }
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        self.dashboardCollectionViewController.notificationCV?.collectionView.reloadData()
                    }, completion: nil)
                }
            }
        }
    }
    
    func updateCurrentDeviceDataCell() {
        if let index = self.dashboardCollectionViewController.settingsTypes[0].firstIndex(of: .device) {
            DispatchQueue.main.async {
                self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                    self.dashboardCollectionViewController.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                }, completion: nil)
            }
        }
    }

    
    func updateDeviceDatas() {
        updateTaskCounts {
            self.updateInactiveDevices {
                self.getCurrentScore {
                    self.updateScans { }
                }
            }
        }
        
    }
    
    // MARK:- Task Count

    func updateTaskCounts(completion : @escaping (()->())) {
        getTaskCount { (taskCount) in
            let currentTaskCount = self.dashboardCollectionViewController.currentDeviceTaskCount
            self.dashboardCollectionViewController.currentDeviceTaskCount = (from: currentTaskCount.to, to: taskCount)
            if currentTaskCount.to != taskCount {
                DispatchQueue.main.async {
                    self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        if let index = self.dashboardCollectionViewController.settingsTypes[0].firstIndex(where: { $0 == .device }) {
                            self.dashboardCollectionViewController.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                        }
                    }, completion: nil)
                }
            }
            completion()
        }
    }
    
    // MARK:- Inactive Devices

    func updateInactiveDevices(completion : @escaping (()->())) {
        getInactiveDevices { (inactiveDeviceDatas, currentDeviceData) in
            let currentInactiveDevices = self.dashboardCollectionViewController.inactiveDevices
            
            if let _ = currentDeviceData {
                self.dashboardCollectionViewController.currentDevice = currentDeviceData
                self.updateCurrentDeviceDataCell()
            }
            
            if let inactivesDevices = inactiveDeviceDatas {
                if currentInactiveDevices.elementsEqual(inactivesDevices, by: { (data, element) -> Bool in data.uuid == element.uuid }) == false {
                    self.dashboardCollectionViewController.inactiveDevices = inactivesDevices
                    self.dashboardCollectionViewController.notificationCV?.deviceDatas = inactivesDevices
                }
            } else {
                self.dashboardCollectionViewController.inactiveDevices = []
            }
            self.updateNotificationDeviceDataSectionIfNeeded()
            completion()
        }
    }
    
    
    // MARK:- Get Score

    var lastScore : CGFloat = 0
    
    func getCurrentScore(completion : @escaping (()->())) {
        getScore { (score, isTokenValid) in
            
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.getCurrentScore(completion: completion)
                    } else {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
                    }
                    return
                })
            }
            
            
            if let score = score {
                self.dashboardCollectionViewController.securityScore = (from : Float(self.lastScore), to : Float(score))
                let reloadNeeded = score != Int(self.lastScore)
                self.lastScore = CGFloat(score)
                
                if reloadNeeded == true {
                    DispatchQueue.main.async {
                        self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                            self.dashboardCollectionViewController.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
                        }, completion: nil)
                    }
                }
            } else {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
            }
            completion()
        }
    }
    
    // MARK:- Get Scans
    
    func updateScans(completion : @escaping (()->())) {
        getScans { (scanDataArray, isTokenValid) in
            
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.updateScans(completion: completion)
                    } else {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
                    }
                    return
                })
            }
            
            if let scanDatas = scanDataArray {
                DispatchQueue.main.async {
                    self.dashboardCollectionViewController.scanDatas = scanDatas
                    self.dashboardCollectionViewController.collectionView.performBatchUpdates({
                        
                        if scanDatas.count == 0 {
                            if let index = self.dashboardCollectionViewController.settingsTypes[0].firstIndex(of: .scan) {
                                self.dashboardCollectionViewController.settingsTypes[0].remove(at: index)
                                self.dashboardCollectionViewController.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                            }
                        } else {
                            if let index = self.dashboardCollectionViewController.settingsTypes[0].firstIndex(of: .scan) {
                                self.dashboardCollectionViewController.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                            } else {
                                self.dashboardCollectionViewController.settingsTypes[0].append(DashboardCollectionViewController.SettingsType.scan)
                                let index = self.dashboardCollectionViewController.settingsTypes[0].count - 1
                                self.dashboardCollectionViewController.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                            }
                        }
                        

                    }, completion: nil)
                }
            } else {
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
            }
            completion()
        }
    }
    
    
    // MARK:- API Requests

    
    func getInactiveDevices(completion : @escaping (([DeviceData]?, DeviceData?)->())) {
        
        var deviceDataArray : [DeviceData] = []
        var currentPage = 0
        
        func getData(at page : Int) {
            DevicesAPIStore().fetchDevices { (deviceDatas, error, isTokenValid, hasMorePages) in
                let inactiveDeviceDatas = deviceDatas?.filter{ $0.status != .active }
                let currentDeviceData = deviceDatas?.filter({ $0.thisDevice == true })
                
                deviceDataArray.append(contentsOf: inactiveDeviceDatas ?? [])
                
                if error != nil {
                    self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
                    return
                }
                
                if isTokenValid == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.getInactiveDevices(completion: completion)
                        } else {
                            self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
                        }
                    })
                    return
                }
                
                if hasMorePages == true {
                    currentPage += 1
                    getData(at: currentPage)
                    return
                }
                
                completion(deviceDataArray, currentDeviceData?.first)
            }
        }
        
        getData(at: currentPage)
    }
    
    func getTaskCount(completion : @escaping ((Int)->())) {
        
        getTasks { (totalUnresolvedCount, isTokenValid) in
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.getTaskCount(completion: completion)
                    } else {
                        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
                    }
                    return
                })
            } else if let count = totalUnresolvedCount {
                completion(count)
            } else {
                completion(0)
                self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.an_error_occured, completion: {})
            }
        }
    }
    
    func getTasks(completion : @escaping ((Int?, Bool)->())) {
        
        guard let url = CyberExpertAPIEndpoint.filterToDos(0, ["low", "medium", "high"], ["to_be_completed", "overdue", "postponed"], [UserData.shared.currentDeviceUuid]).url() else { completion(nil, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
                      
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            
            guard let data = data else { completion(nil, false); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let _ = json_object["items"] as? [[String : Any]] {
                    if let meta = json_object["meta"] as? [String : Any], let counter = meta["total_items_unsolved"] as? Int {
                        completion(counter, true)
                        return
                    }
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, false); return }
                    }
                }
            } catch {}
                completion(nil, true)
            }
    }
    
    func getScore(completion : @escaping ((Int?, Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.getScore.url() else { completion(nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, true); return }

            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let score = json_object["value_formatted"] as? Int {
                    completion(score, true)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let code = dataObj["code"] as? Int {
                        if code == 401 { completion(nil, false); return }
                    }
                }
            } catch {}
            completion(nil, true)
        }
    }
    
    func getScans(completion : @escaping (([ScanData]?, Bool)->())) {
        guard let url = CyberExpertAPIEndpoint.getScans.url() else { completion(nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, true); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                                
                let now = Date().timeIntervalSince1970
                
                if let items = json_object["items"] as? [[String : Any]] {
                    var scanDatas : [ScanData] = []
                    for item in items {
                        if let name = item["name"] as? String {
                            let lastScan = item["last_activate"] as? Int ?? Int(now)
                            let scanStatus : ScanStatus = item["is_active"] as? Int == 0 ? ScanStatus.disabled : ScanStatus.enabled
                            let scanData = ScanData(scanType: ScanType.init(name: name)!, lastScan: lastScan, taskCount: 0, scanStatus: scanStatus)
                            scanDatas.append(scanData)
                        }
                    }
                    completion(scanDatas, true)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let code = dataObj["code"] as? Int {
                        if code == 401 { completion(nil, false); return }
                    }
                }
                completion(nil, true)
                return
            } catch {}
            completion(nil, true)
        }
    }
    
    static func logOutUserDueToBadToken() {
        let loginVC = DashboardViewController.logoutUserWithoutError()
        loginVC.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.you_have_been_automaticly_logout]))
    }
    
    static func logoutUserWithoutError() -> LoginViewController {
        UserData.shared.localUserData.token = nil
        UserData.shared.localUserData.refreshToken = nil
        UserData.shared.localUserData.lastUsedAccountUuid = nil
        UserData.shared.currentPlan = PlanData(uuid: "", name: "", slug: "", type: "", status: false)
        let loginVC = LoginViewController()
        ((UIApplication.shared.delegate as? AppDelegate)!.window!.rootViewController! as? UINavigationController)?.setViewControllers([loginVC], animated: false)
        return loginVC
    }
    
}

extension DashboardViewController : UserSelectableTab {
    func tabDeselected() {
        
    }
    
    func userDidSelectTab() {
        updateDeviceDatas()
    }
}







