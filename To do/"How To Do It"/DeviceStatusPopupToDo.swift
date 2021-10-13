//
//  DeviceStatusPopupToDo.swift
//  Xpert
//
//  Created by Darius on 2020-02-11.
//  Copyright © 2020. All rights reserved.
//

import UIKit

enum TaskActionSlug : String {
    case updateSoftware = "out_of_date_os"
    case jailbreakCheck = "ios_root_check"
    case screenLock = "enable_screen_lock"
}

struct TaskActionSlugStruct {
    var taskActionSlug : TaskActionSlug
    var value : String?
}

class DeviceStatusPopupToDo: HowToPopupViewController {
    
    let slug : String
    
    init(actionSlugString slug : String) {
        self.slug = slug
        super.init(taskData: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func fetchData() {
        fetchSlugToDoTaskData { (success, isTokenValid) in
            if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.fetchToDoTaskData(completion: { (suc) in
                            if suc == false { self.tokenUpdateFailedLogoutUser() }
                        })
                    } else {
                        self.tokenUpdateFailedLogoutUser()
                    }
                })
            }
            if success == false {
                DispatchQueue.main.async {
                    self.presentSimpleOKError(withTitle: Localization.shared.server_error, andSubtitle: "") {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
        
    
    func fetchSlugToDoTaskData(completion : @escaping ((Bool, Bool)->())) {
                                
        guard let newSlug = (slug as NSString).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = CyberExpertAPIEndpoint.getTodoForSlug(newSlug).url() else { completion(false, true); return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
            
        NetworkClient.shared.sendRequest(needAuth: true, request: request, completion: { (data, _, error) in
            
            do {
                let json_object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(true, false); return }
                    }
                }
                
                if CyberExpertAPI.isProduction != true {
                    print("### GET TASK WITH SLUG: ", json_object)
                }
                
                //if let actionUuid = json_object["action_uuid"] as? String {
                //  self.uuid = actionUuid this one crashes when ticking checkbox
                //}
               
                var sectionDataArray : [ToDoTaskSectionData] = []
               
                let priority = json_object["priority"] as? String ?? ""

                let title = json_object["title"] as? String ?? ""
                let status = json_object["status"] as? String ?? ""

                if let deviceData = json_object["device"] as? [String : Any] {
                    let device = Device(name: deviceData["title"] as? String ?? "", type: DeviceType(string: deviceData["name"] as? String ?? ""))
                    let uuid = deviceData["uuid"] as? String ?? ""
                    self.infoView.data = TaskData(uuid: uuid, name: title, priority: TaskPriority(string: priority), status: TaskStatus(string: status), device: device, dueTime: nil, reminderTime: nil, isEnabled: true)
                } else {
                    self.infoView.data = TaskData(uuid: "", name: title, priority: TaskPriority(string: priority), status: TaskStatus(string: status), device: Device(name: "", type: .apple), dueTime: nil, reminderTime: nil, isEnabled: true)
                }
               
                var stepsDataArray : [ToDoStepsData] = []
               
                if let title = json_object["title"] as? String, let text = json_object["description"] as? String {
                    self.howToCollectionViewController.instructions = ToDoInstructionsData(title: title, text: text, checklistData: [])
                    sectionDataArray.append(ToDoTaskSectionData(section: .instructions, visible: false))
                }
                
                if let whyNecessary = json_object["why_necessary"] as? String, whyNecessary.count > 0 {
                    sectionDataArray.append(ToDoTaskSectionData(section: .blueInfo, visible: false))
                    self.howToCollectionViewController.toDoBlueInfoData = ToDoBlueInfoData(title: Localization.shared.why_ti_is_necessary, text: whyNecessary, checkListData: [], icon: #imageLiteral(resourceName: "security_ic"))
                }

                if let stepsData = json_object["steps"] as? [String : Any] {
                   
                    var data : [(index : Int, text : ToDoStepsData)] = []
                   
                    for (i, step) in stepsData {

                        let t : String = ((step as? [String : Any])?["data"] as? String) ?? "asdasd"
                        data.append((index: Int(i)!, text: ToDoStepsData(markdown: t, attrString: nil)))
                    }
                                       
                    data.sort(by: { $0.index < $1.index })
                   
                    for d in data {
                        stepsDataArray.append(d.text)
                    }
                   
                    sectionDataArray.append(.init(section: .steps, visible: true))
                    self.howToCollectionViewController.stepData = stepsDataArray

                }
               
                sectionDataArray.append(ToDoTaskSectionData(section: .moreButton, visible: false))
                self.howToCollectionViewController.buttonData = ToDoButtonData(name: Localization.shared.need_more_help.uppercased()+" ", url: "")
               
                self.howToCollectionViewController.sections = sectionDataArray
               
                DispatchQueue.main.async {
                    self.howToCollectionViewController.collectionView.reloadData()
                }
               
                completion(true, true)
               
            } catch {}
            
            completion(true, true)
         })
    }
    
}
