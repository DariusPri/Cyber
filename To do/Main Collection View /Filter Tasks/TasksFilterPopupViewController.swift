//
//  TasksFilterPopupViewController.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

class TasksFilterPopupViewController: PopupViewController, ErrorPresenter {
    
    let filterCollectionViewController = FilterCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(filterCollectionViewController)
        filterCollectionViewController.didMove(toParent: self)

        containerView.addSubview(filterCollectionViewController.view)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: filterCollectionViewController.view)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1]|", views: headerView, filterCollectionViewController.view)

        fetchDevices()
    }
    
    func fetchDevices() {
        self.fetchDevices { (deviceDatas, error, isGoodToken) in
            if error != nil {
                DispatchQueue.main.async {
                    self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: Localization.shared.server_error) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                return
            }
            
            if let dDatas = deviceDatas {
                DispatchQueue.main.async {
                    self.filterCollectionViewController.deviceDataArray = dDatas.map({ DeviceFilterData(deviceData: $0) })
                    self.filterCollectionViewController.collectionView.reloadData()
                    self.filterCollectionViewController.setFiltersIfNeeded()
                }
            } else {
                if isGoodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.fetchDevices()
                        } else {
                            DispatchQueue.main.async {
                                DashboardViewController.logOutUserDueToBadToken()
                            }
                        }
                    })
                }
            }
        }
    }
    
    
    func fetchDevices(completion: @escaping ([DeviceData]?, Error?, Bool) -> ()) {
        
        guard let url = CyberExpertAPIEndpoint.getDevices.url() else { completion(nil, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, nil, true); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let deviceDatasFromRequest = json_object["items"] as? [[String : Any]] {
                    
                    var deviceDatas : [DeviceData] = []
                    for d in deviceDatasFromRequest {
                        let uuid = d["uuid"] as? String ?? ""
                        let name = d["name"] as? String ?? ""
                        let type = d["device_type"] as? String ?? ""
                        let status = d["status"] as? String ?? ""
                        let os = d["os"] as? String ?? ""
                        let fingerprint = d["fingerprint"] as? String ?? ""
                        
                        var taskCount = 0
                        if let counters = d["counters"] as? [String : Any] {
                            taskCount = counters["count_user_action_unsolved"] as? Int ?? 0
                        }
                        
                        deviceDatas.append(DeviceData(name: name, type: type, os: DeviceOS(text: os), status: DeviceStatus(text: status), thisDevice: false, taskCount: taskCount, uuid: uuid, fingerprint: fingerprint))
                        
                    }
                    completion(deviceDatas, nil, true)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, nil, false); return }
                    }
                }
            } catch {}
            completion(nil, nil, true)
        }
        
    }
        
    
    
}
