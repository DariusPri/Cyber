//
//  DashboardCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 2020-01-16.
//  Copyright © 2020. All rights reserved.
//

enum ScanStatus {
    case enabled
    case disabled
}

struct ScanData {
    var scanType : ScanType
    var lastScan : Int
    var taskCount : Int
    var scanStatus : ScanStatus
}


import LocalAuthentication
import UIKit


class DashboardCollectionViewController: UICollectionViewController {
        
    var inactiveDevices : [DeviceData] = []
    var currentDevice : DeviceData?
    var currentDeviceTaskCount : (from: Int, to: Int) = (from: 0, to: 0)
    
    enum SettingsType {
        case securityScore
        case notification
        case device
        case scan
        case deviceStatus
    }
    
    struct NotificationVisibleData {
        var image : UIImage?
        var title : String
    }
    
    enum NotificationStatus {
        case opened
        case closed
    }
    
    struct NotificationData {
        var data : [NotificationVisibleData]
    }
    
    
    var scanDatas : [ScanData] = []
    var settingsTypes : [[SettingsType]] = [[.securityScore, .device], [.deviceStatus, .deviceStatus, .deviceStatus]]
    var notifications : NotificationData = NotificationData(data: [])
    var sectionNames = ["", Localization.shared.dashboard_device_status.uppercased()]
    var securityScore : (from : Float, to : Float) = (from : 0, to : 0)
    var correctCollectionViewWidth : CGFloat = 300
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        setupView()
        registerCells()
    }
    
    func setupView() {
        view.backgroundColor = .clear
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        collectionView.backgroundColor = .clear
        collectionView?.contentInsetAdjustmentBehavior = .never
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .vertical
        (collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).headerReferenceSize = CGSize(width: collectionView!.bounds.size.width, height: 100)
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 740)) / 2
        collectionView?.contentInset = .init(top: view.isHugeScreenSize == true ? 52 : 0, left: 0, bottom: 50, right: 0)
        correctCollectionViewWidth = view.bounds.size.width - horizontalInset * 2
        setupNotificationCV()
    }
    
    func registerCells() {
        collectionView?.register(NotificationCell.self, forCellWithReuseIdentifier: notificationCellIdentifier)
        collectionView?.register(DeviceCell.self, forCellWithReuseIdentifier: deviceCellIdentifier)
        collectionView?.register(ScanCell.self, forCellWithReuseIdentifier: scanCellIdentifier)
        collectionView?.register(DeviceStatusCell.self, forCellWithReuseIdentifier: deviceStatusCellIdentifier)
        collectionView?.register(SecurityScoreCell.self, forCellWithReuseIdentifier: securityScoreCellIdentifier)
        collectionView?.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderViewIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var notificationCV : NotificationCollectionViewController?
    
    func setupNotificationCV() {
        let layout = CustomLayout()
        layout.defaultOffset = view.getCorrectSize(8, 8, 10)
        notificationCV = NotificationCollectionViewController(collectionViewLayout: layout)
        addChild(notificationCV!)
        notificationCV?.didMove(toParent: self)
    }
    
    var taskActions : [(title : String, taskActionSlug : TaskActionSlugStruct)] = [(title : Localization.shared.forgot_os_at_latest_version, taskActionSlug : TaskActionSlugStruct(taskActionSlug: .updateSoftware, value: nil)), (title : Localization.shared.system_data_access, taskActionSlug : TaskActionSlugStruct(taskActionSlug: .jailbreakCheck, value: nil)), (title : Localization.shared.forgot_screen_lock_enabled, taskActionSlug : TaskActionSlugStruct(taskActionSlug: .screenLock, value: nil))]
}

// MARK:- UICollectionView Setup

extension DashboardCollectionViewController : UICollectionViewDelegateFlowLayout {

    override func numberOfSections(in collectionView: UICollectionView) -> Int { return settingsTypes.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return settingsTypes[section].count }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = correctCollectionViewWidth - 2 * 15
        switch settingsTypes[indexPath.section][indexPath.item] {
        case .securityScore: return CGSize(width: width, height: view.getCorrectSize(256, 256, 332))
        case .device: return CGSize(width: width, height: view.getCorrectSize(263, 263, 342))
        case .deviceStatus: return CGSize(width: width, height: view.getCorrectSize(80, 80, 100))
        case .notification: return CGSize(width: width, height: view.getCorrectSize(133, 133, 182))
        case .scan: return CGSize(width: correctCollectionViewWidth, height: view.getCorrectSize(130, 350, 410)) }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return formatCell(withType: settingsTypes[indexPath.section][indexPath.item], indexPath: indexPath)
    }
    
    func formatCell(withType settingsType : SettingsType, indexPath : IndexPath) -> UICollectionViewCell {
        
        var cell : SettingsCell
        
        switch settingsType {
        case .notification:
            let notificationCell = collectionView?.dequeueReusableCell(withReuseIdentifier: notificationCellIdentifier, for: indexPath) as! NotificationCell
            notificationCV?.deviceDatas = inactiveDevices
            notificationCV?.collectionView.reloadData()
            notificationCell.setupNotificationCV(with: notificationCV!)
            cell = notificationCell
            break
        case .device:
            cell = collectionView?.dequeueReusableCell(withReuseIdentifier: deviceCellIdentifier, for: indexPath) as! DeviceCell
            (cell as! DeviceCell).updateUI(with: currentDevice)
            (cell as! DeviceCell).tasksCounterLabel.count(from: Float(currentDeviceTaskCount.from), to: Float(currentDeviceTaskCount.to), duration: 2)
            break
        case .scan:
            let scanCell = collectionView?.dequeueReusableCell(withReuseIdentifier: scanCellIdentifier, for: indexPath) as! ScanCell
            if scanCell.scanCardsCV == nil {
                scanCell.setupScanCV()
                addChild(scanCell.scanCardsCV!)
                scanCell.scanCardsCV!.didMove(toParent: self)
            }
            scanCell.scanCardsCV?.scanDatas = scanDatas
            scanCell.scanCardsCV?.collectionView?.reloadData()
            scanCell.scanCardsCV?.scanCardsDelegate = self
            cell = scanCell
            break
        case .deviceStatus:
            cell = collectionView?.dequeueReusableCell(withReuseIdentifier: deviceStatusCellIdentifier, for: indexPath) as! DeviceStatusCell
            guard let cell = cell as? DeviceStatusCell else { break }
            cell.actionButton.tag = indexPath.item
            cell.actionButton.addTarget(self, action: #selector(deviceStatusAction(sender:)), for: .touchUpInside)
            if indexPath.item == 0 { cell.statusTitleLabel.text = taskActions[indexPath.item].title
                cell.setImageViewTick(enabled: taskActions[indexPath.item].taskActionSlug.value == nil)
            }
            if indexPath.item == 1 { cell.statusTitleLabel.text = taskActions[indexPath.item].title
                cell.setImageViewTick(enabled: !DashboardCollectionViewController.canWriteSystemFiles())
            }
            if indexPath.item == 2 { cell.statusTitleLabel.text = taskActions[indexPath.item].title
                cell.setImageViewTick(enabled: DashboardCollectionViewController.screenLockEnabled())
            }
            break
        case .securityScore:
            cell = collectionView?.dequeueReusableCell(withReuseIdentifier: securityScoreCellIdentifier, for: indexPath) as! SecurityScoreCell
            (cell as! SecurityScoreCell).scoreLabel.text = "\(securityScore.from)"
            (cell as! SecurityScoreCell).scoreLabel.count(from: securityScore.from, to: securityScore.to, duration: 2.0)
            (cell as! SecurityScoreCell).scoreLabel.completion = { self.securityScore.from = self.securityScore.to }
            (cell as! SecurityScoreCell).loader?.score = CGFloat(securityScore.from)
            (cell as! SecurityScoreCell).loader?.animateToScore = CGFloat(securityScore.to)
            (cell as! SecurityScoreCell).loader?.animate()
        }
        return cell
    }
    
    static func screenLockEnabled() -> Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    static func canWriteSystemFiles() -> Bool {
        return FileManager.default.fileExists(atPath: "/private/var/lib/apt")
    }
    
    @objc func deviceStatusAction(sender : UIButton) {
        sender.isEnabled = false
        if let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 1)) as? DeviceStatusCell {
            cell.iconImageView.startLoaderAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                cell.iconImageView.stopLoaderAnimation()
                self.collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 1)])
            }
        }
                
        presentActionForDeviceVersionStatus(with: taskActions[sender.tag].taskActionSlug.value)
        
    }
    
    func presentActionForDeviceVersionStatus(with slug: String?) {
        guard let slug = slug, slug.count > 0 else { return }
        DispatchQueue.main.async {
            let howToPopupViewController = DeviceStatusPopupToDo(actionSlugString: slug)
            howToPopupViewController.modalPresentationStyle = .overCurrentContext
            howToPopupViewController.transitioningDelegate = howToPopupViewController
            howToPopupViewController.popupCloseCompletion = {}
            self.navigationController!.present(howToPopupViewController, animated: true, completion: nil)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: sectionHeaderViewIdentifier, for: indexPath) as! SectionHeaderView
            headerView.leftConstraint?.constant = (collectionView.bounds.size.width - correctCollectionViewWidth) / 2 + 30
            headerView.sectionHeaderLabel.text = Localization.shared.dashboard_device_status.uppercased()
            headerView.frame.size.height = indexPath.section == 0 ? 0 : view.getCorrectSize(60, 60, 72)
            headerView.frame.size.width = view.bounds.size.width
            headerView.frame.origin.x = 0
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return section == 0 ? 20 : 0 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: correctCollectionViewWidth, height: section == 0 ? 0 : view.getCorrectSize(60, 60, 72))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 15, right: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    func showScanPopup(for index : Int) {
        if view.isSmallScreenSize == true {
            let scanPopupViewController = ScanPopupViewController(scanData: scanDatas[index])
            scanPopupViewController.modalPresentationStyle = .overCurrentContext
            scanPopupViewController.transitioningDelegate = scanPopupViewController
            scanPopupViewController.popupCloseCompletion = {}
            self.present(scanPopupViewController, animated: true, completion: nil)
        } else {
            guard let sIndex = settingsTypes.firstIndex(where: { $0.contains(.scan) }), let cIndex = settingsTypes[sIndex].firstIndex(where: { $0 == .scan }) else { return }
            let currentOffset = collectionView!.contentOffset
            collectionView?.setContentOffset(currentOffset, animated: false)
            let parentCell = collectionView?.cellForItem(at: IndexPath(item: cIndex, section: sIndex)) as! ScanCell
            let cell = parentCell.scanCardsCV?.collectionView?.cellForItem(at: IndexPath(item: index, section: 0))
            let wideVC = ScanWidePopupViewController(scanData: scanDatas[index], sourceRect: cell!.convert(cell!.bounds, to: nil))
            wideVC.modalPresentationStyle = .custom
            self.present(wideVC, animated: false, completion: nil)
        }
    }
    
}



extension DashboardCollectionViewController : ScanCardsProtocol {
    func didSelected(at index: Int) {
        showScanPopup(for: index)
    }
}
