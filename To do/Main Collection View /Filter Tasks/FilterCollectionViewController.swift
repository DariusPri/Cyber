//
//  FilterCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 30/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

enum TaskPriority : String {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    func localized() -> String {
        
        switch self {
        case .low:
            return Localization.shared.to_do_filter_low_risk.uppercased()
        case .medium:
            return Localization.shared.to_do_filter_medium_risk.uppercased()
        case .high:
            return Localization.shared.to_do_filter_high_risk.uppercased()
        }
        
    }
    
    init(string : String) {
        switch string {
        case "high":
            self = .high
        case "medium":
            self = .medium
        default:
            self = .low
        }
    }
}

enum TaskStatus : String {
    case toDo = "To do"
    case completed = "Completed"
    case overdue = "Overdue"
    case postponed = "Postponed"
    
    init(string : String) {
        switch string {
        case "to_be_completed":
            self = .toDo
        case "completed":
            self = .completed
        case "overdue":
            self = .overdue
        case "postponed":
            self = .postponed
        default:
            self = .toDo
        }
    }
    
    func toString() -> String {
        switch self {
        case .toDo:
            return "to_be_completed"
        case .completed:
            return "completed"
        case .overdue:
            return "overdue"
        case .postponed:
            return "postponed"
        }
    }
    
    func localized() -> String {
        switch self {
        case .toDo:
            return Localization.shared.to_do
        case .completed:
            return Localization.shared.to_do_filter_completed
        case .overdue:
            return Localization.shared.overdue
        case .postponed:
            return Localization.shared.postponed
        }
    }
}

enum DeviceType : String {
    case desktop = "Desktop"
    case personal = "Personal"
    case laptop = "Laptop"
    case tablet = "Tablet"
    case phone = "Phone"
    case apple = "Apple"
    case android = "Android"
    case windows = "Windows"
    
    init(string : String) {
        switch string.lowercased() {
        case "desktop", "pc":
            self = .desktop
            break
        case "personal" :
            self = .personal
            break
        case "laptop":
            self = .laptop
            break
        case "tablet":
            self = .tablet
            break
        case "phone":
            self = .phone
            break
        case "apple":
            self = .apple
            break
        case "android":
            self = .android
            break
        case "windows":
            self = .windows
            break
        default:
            self = .personal
        }
    }
}

struct Device {
    var name : String
    var type : DeviceType
}

struct FilterData {
    var priorities : [TaskPriority]
    var status : [TaskStatus]
    var devices : [Device]
}


enum TaskSectionType : String {
    case priority = "PRIORITY"
    case status = "STATUS"
    case device = "DEVICE"
    
    func localized() -> String {
        switch self {
        case .priority:
            return Localization.shared.to_do_filter_priority.uppercased()
        case .status:
            return Localization.shared.status_filter_placeholder.uppercased()
        case .device:
            return Localization.shared.device_filter_placeholder.uppercased()
        }
    }
}
struct PriorityFilterData {
    var priority : TaskPriority
    var count : Int
    var isSelected : Bool
}

struct StatusFilterData {
    var status : TaskStatus
    var isSelected : Bool
}

struct DeviceFilterData {
    var device : DeviceData
    var isSelected : Bool
    
    init(deviceData : DeviceData) {
        self.device = deviceData
        self.isSelected = false
    }
}



class FilterCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let sectionHeaders : [TaskSectionType] = [.priority, .status, .device]
    var priorityDataArray : [PriorityFilterData] = [PriorityFilterData(priority: .low, count: 10, isSelected: false), PriorityFilterData(priority: .medium, count: 29, isSelected: false), PriorityFilterData(priority: .high, count: 30, isSelected: false)]
    var statusDataArray : [StatusFilterData] = [StatusFilterData(status: .toDo, isSelected: false), StatusFilterData(status: .completed, isSelected: false), StatusFilterData(status: .postponed, isSelected: false), StatusFilterData(status: .overdue, isSelected: false)]
   
    var deviceDataArray : [DeviceFilterData] = []
        
    var horizontalSpacing : CGFloat = 15
    
    var filteredPriorityDataArray : [PriorityFilterData] = []
    var filteredStatusDataArray : [StatusFilterData] = []
    var filteredDeviceDataArray : [DeviceFilterData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalSpacing = view.getCorrectSize(15, 15, 18)
        self.collectionView!.register(FilterSelectionCollectionViewCell.self, forCellWithReuseIdentifier: "FilterSelectionCollectionViewCell")
        self.collectionView!.register(FilterTasksSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterTasksSectionHeader")
        self.collectionView!.contentInset = .init(top: 40, left: 2 * horizontalSpacing, bottom: 0, right: 2 * horizontalSpacing)
        (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = view.getCorrectSize(15, 15, 22)
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.allowsMultipleSelection = true
    }
    
    func setFiltersIfNeeded() {
        if filteredPriorityDataArray.count == 0 && filteredStatusDataArray.count == 0 && filteredDeviceDataArray.count == 0 { return }
            
        for (i,_) in priorityDataArray.enumerated() {
            if filteredPriorityDataArray.contains(where: { $0.priority == self.priorityDataArray[i].priority }) == true {
                self.priorityDataArray[i].isSelected = true
                self.collectionView.selectItem(at: IndexPath(item: i, section: 0), animated: false, scrollPosition: .top)
            }
        }
        
        for (i,_) in statusDataArray.enumerated() {
            if filteredStatusDataArray.contains(where: { $0.status == self.statusDataArray[i].status }) == true {
                self.statusDataArray[i].isSelected = true
                self.collectionView.selectItem(at: IndexPath(item: i, section: 1), animated: false, scrollPosition: .top)
            }
        }
        
        for (i,_) in deviceDataArray.enumerated() {
            if filteredDeviceDataArray.contains(where: { $0.device.uuid == self.deviceDataArray[i].device.uuid }) == true {
                self.deviceDataArray[i].isSelected = true
                self.collectionView.selectItem(at: IndexPath(item: i, section: 2), animated: false, scrollPosition: .top)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return sectionHeaders.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionHeaders[section] {
        case .device: return deviceDataArray.count
        case .priority: return priorityDataArray.count
        case .status: return statusDataArray.count}
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterSelectionCollectionViewCell", for: indexPath) as! FilterSelectionCollectionViewCell
        switch sectionHeaders[indexPath.section] {
            case .priority: cell.setupData(with: priorityDataArray[indexPath.item], status: nil, device: nil)
            case .status: cell.setupData(with: nil, status: statusDataArray[indexPath.item], device: nil)
            case .device: cell.setupData(with: nil, status: nil, device: deviceDataArray[indexPath.item])
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = collectionView.getCorrectSize(75, 75, 100)
        let width : CGFloat = (collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right - 2 * horizontalSpacing)/3
        if sectionHeaders[indexPath.section] == .device { height = collectionView.getCorrectSize(95, 95, 128) }
        return CGSize(width: width - collectionView.getCorrectSize(0, 0, 4), height: height)
    }
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FilterTasksSectionHeader", for: indexPath) as! FilterTasksSectionHeader
        header.titleLabel.text = sectionHeaders[indexPath.section].localized()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - horizontalSpacing * 2, height: collectionView.getCorrectSize(30, 30, 42))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: collectionView.getCorrectSize(25, 25, 32), right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch sectionHeaders[indexPath.section] {
        case .priority: priorityDataArray[indexPath.item].isSelected = true
        case .status: statusDataArray[indexPath.item].isSelected = true
        case .device: deviceDataArray[indexPath.item].isSelected = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch sectionHeaders[indexPath.section] {
        case .priority: priorityDataArray[indexPath.item].isSelected = false
        case .status: statusDataArray[indexPath.item].isSelected = false
        case .device: deviceDataArray[indexPath.item].isSelected = false
        }
    }
}

