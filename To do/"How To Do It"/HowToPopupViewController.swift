//
//  HowToCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 17/09/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


enum ToDoTaskSection : String {
    case instructions = "Instructions"
    case recomendations = "We recommend"
    case steps = "Steps"
    case moreButton = "Need more help"
    case additionalOptions = "Additional options"
    case rawDataExposed = "Raw Data Exposed"
    case blueInfo = ""
    case mainData
    
    func localized() -> String {
        switch self {
        case .instructions:
            return Localization.shared.instructions_header
        case .recomendations:
            return Localization.shared.we_recommend_header
        case .steps:
            return Localization.shared.steps
        case .moreButton:
            return Localization.shared.need_more_help
        case .additionalOptions:
            return Localization.shared.additional_options_header
        case .rawDataExposed:
            return Localization.shared.raw_data_exposed
        default:
            return ""
        }
    }
}

struct RawDataExposedData {
    var dataString : String
}

struct ToDoTaskSectionData {
    var section : ToDoTaskSection
    var visible : Bool
}

struct CheckListData {
    var text : String
    var imageUrl : String?
    var imageHeight : CGFloat?
    var isDownloaded : Bool
}

struct ToDoInstructionsData {
    var title : String
    var text : String
    var checklistData : [CheckListData]
}

struct TodoMainData {
    var sectionName : String
    var header : String
    var icon : UIImage
    var subtitle : String?
    var redFlag : String?
    var accExposed : [String]?
    var explainedText : String?
    var checkListData : [String]?
}

struct ToDoStepsData {
    var markdown : String
    var attrString : NSAttributedString?
}

struct ToDoRecomendationData {
    var name : String
    var price : Float
    var url : String
}

struct ToDoAdditionalOptionData {
    var name : String
    var icon : UIImage
    var statusEnabled : Bool
}

struct ToDoButtonData {
    var name : String
    var url : String
}


struct ToDoBlueInfoData {
    var title : String
    var text : String
    var checkListData : [String]
    var icon : UIImage
}


class HowToPopupViewController: PopupViewController, ErrorPresenter {
    
    var todoInputDelegate: ToDoViewControllerInput?
    
    private var keyboardHeightLayoutConstraint : CGFloat = 0
    let howToCollectionViewController = HowToCollectionViewController(collectionViewLayout: HowToCollectionViewFlowLayout())
    
    var uuid : String?
    let initialStatus : TaskStatus?

    init(taskData : TaskData? = nil) {
        self.uuid = taskData?.uuid
        self.infoView.data = taskData
        self.initialStatus = taskData?.status
        super.init(title: Localization.shared.to_do, rightButton: nil)
    }

    
    func fetchData() {
        fetchToDoTaskData { (isTokenValid) in
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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        
        containerView.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        
        containerView.addSubview(howToCollectionViewController.view)
        addChild(howToCollectionViewController)
        howToCollectionViewController.didMove(toParent: self)
        
        setupBottomView()
        addKeyboardNotification()

    }
    
    func tokenUpdateFailedLogoutUser() {
        DashboardViewController.logOutUserDueToBadToken()
        self.dismiss(animated: true, completion: nil)
    }
    
    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if initialStatus != infoView.data?.status {
            todoInputDelegate?.updateAfterCheckboxAction()
        }
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint = 0.0
            } else {
                self.keyboardHeightLayoutConstraint = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.setFrames()
                            self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func setFrames() {
        if self.keyboardHeightLayoutConstraint < 1 {
            self.howToCollectionViewController.view.frame = CGRect(x: 0, y: self.headerView.frame.maxY, width: containerView.bounds.size.width, height: UIScreen.main.bounds.size.height - self.headerView.frame.maxY - (self.infoView.bounds.size.height) - (self.keyboardHeightLayoutConstraint ))
        } else {
            self.howToCollectionViewController.view.frame = CGRect(x: 0, y: self.headerView.frame.maxY, width: containerView.bounds.size.width, height: UIScreen.main.bounds.size.height - headerView.frame.maxY - (infoView.bounds.size.height) - (keyboardHeightLayoutConstraint - infoView.frame.size.height))
        }
        self.howToCollectionViewController.collectionView?.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFrames()
    }
    
    func fetchToDoTaskData(completion : @escaping ((Bool)->())) {

        guard let uuid = uuid, let url = CyberExpertAPIEndpoint.getTodoForUuid(uuid).url() else { return }
        var request = URLRequest.jsonRequest(url: url)
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = "GET"
        
        NetworkClient.shared.sendRequest(needAuth: true, request: request) { (data, _, error) in
            
            guard let data = data else { completion(false); return }
            
            do {
                let json_object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
                if let dataObj = json_object["data"] as? [String : Any] {
                    if let name =  dataObj["code"] as? Int {
                        if name == 401 { completion(false); return }
                    }
                }
                
                var sectionDataArray : [ToDoTaskSectionData] = []
                
                let priority = json_object["priority"] as? String ?? ""

                let title = json_object["title"] as? String ?? ""
                let status = json_object["status"] as? String ?? ""

                if let deviceData = json_object["device"] as? [String : Any] {
                    let device = Device(name: deviceData["title"] as? String ?? "", type: DeviceType(string: deviceData["name"] as? String ?? ""))
                    let uuid = deviceData["uuid"] as? String ?? ""
                    self.infoView.data = TaskData(uuid: uuid, name: title, priority: TaskPriority(string: priority), status: TaskStatus(string: status), device: device, dueTime: nil, reminderTime: nil, isEnabled: true)
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
                
                if let breachData = json_object["breach_raw_data"] as? String, breachData.count > 0 {
                    sectionDataArray.append(.init(section: .rawDataExposed, visible: true))
                    self.howToCollectionViewController.rawDataExposedData = .init(dataString: breachData)
                }
                
                sectionDataArray.append(ToDoTaskSectionData(section: .moreButton, visible: false))
                self.howToCollectionViewController.buttonData = ToDoButtonData(name: Localization.shared.need_more_help.uppercased()+" ", url: "")
                
                self.howToCollectionViewController.sections = sectionDataArray
                
                DispatchQueue.main.async {
                    self.howToCollectionViewController.collectionView.reloadData()
                }
                
                completion(true)
                
            } catch {}
        }
    }
        
    
    let infoView = HowToInfoView()

    func setupBottomView() {
        containerView.addSubview(infoView)
        containerView.addConstraintsWithFormat(format: "H:|[v0]|", views: infoView)
        containerView.addConstraintsWithFormat(format: "V:[v0]|", views: infoView)
        
        infoView.checkBoxButton.addTarget(self, action: #selector(statusCheckboxTicked(sender:)), for: .touchUpInside)
    }
        
    @objc func statusCheckboxTicked(sender : UIButton) {
        guard let uuid = uuid, let status = infoView.data?.status else { return }
        sender.isUserInteractionEnabled = false
        var newStatus : TaskStatus = .completed
        if status == .completed { newStatus = .toDo } else { newStatus = .completed }
        ToDoAPIStore().changeTaskStatus(forTaskUuid: uuid, andStatus: newStatus) { (success, error, goodToken) in
            sender.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                if error != nil {
                    self.presentSuccessfulCenterPopup(withIcon: #imageLiteral(resourceName: "trial_ended_logo"), andTitle: Localization.shared.error, andSubtitle: Localization.shared.error_occured)
                }
                if success == true {
                    var data = self.infoView.data
                    data?.status = newStatus
                    self.infoView.data = data
                } else if success == false {
                    self.presentSimpleOKError(withTitle: Localization.shared.error, andSubtitle: Localization.shared.error_occured) {}
                } else if goodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.statusCheckboxTicked(sender: sender)
                        } else {
                            self.presentSuccessfulCenterPopup(withIcon: #imageLiteral(resourceName: "trial_ended_logo"), andTitle: Localization.shared.error, andSubtitle: Localization.shared.you_have_been_automaticly_logout) {
                                self.dismiss(animated: true) {
                                    DashboardViewController.logOutUserDueToBadToken()
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



protocol ReloadCellProtocol : AnyObject {
    func setAttributedStepData(with attrString : NSAttributedString, ip : IndexPath)
}

