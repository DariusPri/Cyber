//
//  NewDeviceAPIStore.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - NewDeviceAPIStore

/// _NewDeviceAPIStore_ is a class responsible for fetching devices
final class NewDeviceAPIStore {
    
}


// MARK: - NewDeviceStoreProtocol

extension NewDeviceAPIStore: NewDeviceStoreProtocol {
    
    
    /// Sends request for a new Device to the server
    ///
    func addNewDevice(deviceTypeString: String, osTypeString: String, name: String?, completion: @escaping (DeviceData?, Error?, Bool) -> ()) {
                        
        guard let url = CyberExpertAPIEndpoint.addNewDevice.url() else { completion(nil, NetworkError.invalidURL, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        var parameters: [String: Any]

        parameters = [
            "name" : name?.count == 0 ? "My \(osTypeString) \(deviceTypeString)" : (name ?? ""),
            "os" : osTypeString,
            "device_type" : deviceTypeString,
            "scan_by" : "app"
        ]

        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, nil, false); return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                
                if let dataObj = json?["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, nil, false); return }
                    }
                }
                
                if let status = json?["status"] as? Bool, status == false {
                    completion(nil, nil, true)
                    return
                }
                
                completion(DeviceData(name: name ?? "", type: deviceTypeString, os: DeviceOS(text: ""), status: DeviceStatus.inactive, thisDevice: false, taskCount: 100, uuid: "", fingerprint: ""), nil, true)
                return
            } catch {}
            
            completion(nil, nil, true)
        }
    }
    
}
