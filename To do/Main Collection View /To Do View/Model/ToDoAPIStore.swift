//
//  ToDoAPIStore.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - ToDoAPIStore

/// _ToDoAPIStore_ is a class responsible for fetching ToDo
final class ToDoAPIStore {
    
}

// MARK: - ToDoStoreProtocol

extension ToDoAPIStore: ToDoStoreProtocol {
    
    /// Fetches a list of  To Do tasks
    ///
    /// - parameter page: page number
    /// - parameter completion: The completion block
    func fetchToDoTasks(page: Int, completion: @escaping ([TaskData]?, Error?, Int, Bool, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.getTodos(page).url() else { completion(nil, NetworkError.invalidURL, 0, false, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            guard let data = data else { completion(nil, NetworkError.generic, 0, false, false); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let itemsDataFromRequest = json_object["items"] as? [[String : Any]] {

                    var taskDataArray: [TaskData] = []
                    
                    for itemData in itemsDataFromRequest {
                        let name = itemData["title"] as? String ?? ""
                        let priority = itemData["priority"] as? String ?? ""
                        let status = itemData["status"] as? String ?? ""
                        let deviceType = (itemData["device"] as? [String : Any])?["device_type"] as? String ?? ""
                        let device = Device(name: itemData["title"] as? String ?? "", type: DeviceType(string: deviceType))
                        let uuid = itemData["uuid"] as? String ?? ""
                        var  active_to = itemData["active_to"] as? Int ?? 0
                        
                        if active_to != 0 {
                            active_to -= itemData["created"] as? Int ?? 0 
                        }
                        
                        let task = TaskData(uuid: uuid, name: name, priority: TaskPriority(string: priority), status: TaskStatus(string: status), device: device, dueTime: active_to / (60 * 60 * 24), reminderTime: nil, isEnabled: true)
                        
                        taskDataArray.append(task)
                    }
                    
                    var hasMoreItems = false
                    var numberOfTasks : Int = 0
                    
                    if let meta = json_object["meta"] as? [String : Any], let currentPage = meta["page_current"] as? Int, let pageCount = meta["page_count"] as? Int, let counter = meta["total_items_unsolved"] as? Int {
                        hasMoreItems = currentPage < pageCount
                        numberOfTasks = counter
                    }
                    
                    
                    completion(taskDataArray, nil, numberOfTasks, true, hasMoreItems)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, nil, 0, false, false); return }
                    }
                }
            } catch {}
            completion(nil, nil, 0, true, false)
        }
        
    }
    
    
    /// Changes a To Do tasks status
    ///
    /// - parameter uuid: tasks unique id
    /// - parameter status: new task status
    /// - parameter completion: The completion block
    func changeTaskStatus(forTaskUuid uuid : String, andStatus status : TaskStatus, completion: @escaping (Bool, Error?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.changeToDoStatus(uuid).url() else { completion(false, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "status" : status.toString()
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
                        
            if let data = data, let json_object = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                
                if let status = json_object?["status"] as? Bool, status == false {
                    completion(false, nil, true)
                    return 
                }
                
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            completion(true, nil, true)
        }
    }
    
    /// Filters To Do tasks
    ///
    /// - parameter page: page number
    /// - parameter priorityStringArray: priority strings array
    /// - parameter statusStringArray: status string array
    /// - parameter deviceUuidArray: device unique ids array
    /// - parameter completion: The completion block
    func filterToDoTasks(at page : Int, with priorityStringArray : [String], statusStringArray : [String], deviceUuidArray : [String], completion: @escaping ([TaskData]?, Error?, Bool, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.filterToDos(page, priorityStringArray, statusStringArray, deviceUuidArray).url() else { completion(nil, nil, false, false); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(nil, nil, false, false); return }
            
            do {
                let json_object  = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                                
                if let itemsDataFromRequest = json_object["items"] as? [[String : Any]] {
                    
                    var taskDataArray: [TaskData] = []
                                        
                    for itemData in itemsDataFromRequest {
                        let name = itemData["title"] as? String ?? ""
                        let priority = itemData["priority"] as? String ?? ""
                        let status = itemData["status"] as? String ?? ""
                        let deviceType = (itemData["device"] as? [String : Any])?["device_type"] as? String ?? ""
                        let device = Device(name: itemData["title"] as? String ?? "", type: DeviceType(string: deviceType))
                        let uuid = itemData["uuid"] as? String ?? ""
                        var  active_to = itemData["active_to"] as? Int ?? 0
                        
                        if active_to != 0 {
                            active_to -= itemData["created"] as? Int ?? 0
                        }
                                                
                        let task = TaskData(uuid: uuid, name: name, priority: TaskPriority(string: priority), status: TaskStatus(string: status), device: device, dueTime: active_to / (60 * 60 * 24), reminderTime: nil, isEnabled: true)
                        taskDataArray.append(task)
                    }
                    
                    var hasMoreItems = false
                    if let meta = json_object["meta"] as? [String : Any], let currentPage = meta["page_current"] as? Int, let pageCount = meta["page_count"] as? Int {
                        hasMoreItems = currentPage < pageCount
                    }
                    
                    completion(taskDataArray, nil, true, hasMoreItems)
                    return
                } else if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(nil, nil, false, false); return }
                    }
                }
            } catch {}
            completion(nil, nil, true, false)
        }
        
    }
    
    /// Sets a reminder for a To Do task
    ///
    /// - parameter uuid: tasks unique id
    /// - parameter durationString: reminder duration string
    /// - parameter completion: The completion block
    func setReminderForTask(with uuid : String, durationString : String, completion: @escaping (Bool, Error?, Bool) -> ()) {
        guard let url = CyberExpertAPIEndpoint.setToDoReminder(uuid).url() else { completion(false, nil, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "status" : "postponed",
            "remind_value" : durationString
        ]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, response, error) in
            if let data = data, let json_object = ((try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) as [String : Any]??), let dataObj = json_object?["data"] as? [String : Any] {
                if let name =  dataObj["code"] as? Int {
                    if name == 401 { completion(false, nil, false); return }
                }
            }
            completion(true, nil, true)
        }
    }
    
}
