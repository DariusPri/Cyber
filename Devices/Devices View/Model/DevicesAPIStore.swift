//
//  DevicesAPIStore.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - DevicesAPIStore

/// _DevicesAPIStore_ is a class responsible for fetching devices
final class DevicesAPIStore {
    
}


// MARK: - DevicesStoreProtocol

extension DevicesAPIStore: DevicesStoreProtocol {
    
    /// Fetches a list of top devices
    ///
    /// - parameter completion: The completion block
    func fetchDevices(completion: @escaping ([DeviceData]?, Error?, Bool, Bool) -> ()) {
        
        guard let url = CyberExpertAPIEndpoint.getDevices.url() else { completion(nil, NetworkError.invalidURL, true, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, NetworkError.generic, true, false); return }

            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let deviceDatasFromRequest = json_object["items"] as? [[String : Any]] {
                    
                    var deviceDatas : [DeviceData] = []
                    for d in deviceDatasFromRequest {
                        let uuid = d["uuid"] as? String ?? ""
                        let name = d["name"] as? String ?? ""
                        let type = d["device_type"] as? String ?? ""
                        let status = d["status"] as? String ?? ""
                        let fingerprint = d["fingerprint"] as? String ?? ""
                        let os = d["os"] as? String ?? ""
                        var taskCount = 0
                        if let counters = d["counters"] as? [String : Any] {
                            taskCount = counters["count_user_action_unsolved"] as? Int ?? 0
                        }
                        deviceDatas.append(DeviceData(name: name, type: type, os: DeviceOS(text: os), status: DeviceStatus(text: status), thisDevice: false, taskCount: taskCount, uuid: uuid, fingerprint: fingerprint))

                    }
                    
                    var hasMoreItems = false
                   
                    if let meta = json_object["meta"] as? [String : Any], let currentPage = meta["page_current"] as? Int, let pageCount = meta["page_count"] as? Int {
                        hasMoreItems = currentPage < pageCount
                    }
                    
                    completion(deviceDatas, nil, true, hasMoreItems)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let code = dataObj["code"] as? Int {
                        if code == 401 { completion(nil, nil, false, false); return }
                    }
                }
            } catch {}
            completion(nil, nil, true, false)
        }
    }
    
    /// Deletes a device
    ///
    /// - parameter uuid: Devices unique id
    /// - parameter completion: The completion block
    func deleteDevice(with uuid : String, completion : @escaping ((Bool, Error?, Bool) -> ())) {
        guard let url = CyberExpertAPIEndpoint.deleteDevice(uuid).url() else { completion(false, NetworkError.invalidURL, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "DELETE"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
                        
            if let data = data, let json_object = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], let dataObj = json_object["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            
            if error == nil {
                completion(true, nil, true); return
            } else if let e = error {
                completion(false, e, true); return
            }
            
            completion(false, nil, true)
        }
    }

}
