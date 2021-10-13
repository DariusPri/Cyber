//
//  AddNewDeviceViewController.swift
//  Xpert
//
//  Created by Darius on 24/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


// MARK: - NewDeviceViewControllerInput

/// _NewDeviceViewControllerInput_ is a protocol for view controller input behaviours
protocol NewDeviceViewControllerInput : AnyObject {
    func newDeviceCreated(with data : DeviceDataViewModel)
}


// MARK: - NewDeviceViewControllerOutput

/// _NewDeviceViewControllerOutput_ is a protocol for view controller output behaviours
protocol NewDeviceViewControllerOutput {
    func addNewDevice(deviceType : Int?, osType : Int?, name : String?)
}


// MARK: - AddNewDeviceCollectionViewController

/// _AddNewDeviceCollectionViewController_ is a view controller responsible for displaying artist details like a list of albums
class AddNewDeviceCollectionViewController: UICollectionViewController, ErrorPresenter {
    
    weak var input : NewDeviceViewControllerInput?
    
    var output: NewDeviceViewControllerOutput!
    var router: NewDeviceRouterProtocol!
    
    // MARK: - Initializers
    
    /// Initializes an instance of _AddNewDeviceCollectionViewController_ with a configurator
    ///
    /// - parameter configurator: The configurator
    ///
    /// - returns: The instance of _AddNewDeviceCollectionViewController_
    init(configurator: NewDeviceConfigurator = NewDeviceConfigurator.sharedInstance) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(configurator: configurator)
    }
    
    /// Initializes an instance of _AddNewDeviceCollectionViewController_ from storyboard
    ///
    /// - parameter coder: The coder
    ///
    /// - returns: The instance of _AddNewDeviceCollectionViewController_
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(configurator: NewDeviceConfigurator.sharedInstance)
    }
    
    // MARK: - Configurator
    
    private func configure(configurator: NewDeviceConfigurator = NewDeviceConfigurator.sharedInstance) {
        configurator.configure(viewController: self)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle { return .default }
    
    let horizontalSpacing : CGFloat = 15
    
    enum SectionType : String {
        case deviceType = "DEVICE TYPE"
        case osType = "OS TYPE"
        case deviceName = "NAME YOUR DEVICE"
        
        func localized() -> String {
            switch self {
            case .deviceType:
                return Localization.shared.add_device_type.uppercased()
            case .deviceName:
                return Localization.shared.add_device_name.uppercased()
            case .osType:
                return Localization.shared.add_os_type.uppercased()
            }
        }
    }
    
    struct NewDeviceData {
        var sectionType : SectionType
        var isOptional : Bool
        var deviceDatas : [(title: String?, deviceType: DeviceType?)]
    }
    
    let newDeviceDatas : [NewDeviceData] = [NewDeviceData(sectionType: .deviceType, isOptional: false, deviceDatas: [(title: Localization.shared.device_type_phone.uppercased(), deviceType: .phone), (title: Localization.shared.device_type_tablet.uppercased(), deviceType: .tablet), (title: Localization.shared.device_type_pc.uppercased(), deviceType: .desktop)]), NewDeviceData(sectionType: .osType, isOptional: false, deviceDatas: [(title: "APPLE", deviceType: .apple), (title: "ANDROID", deviceType: .android), (title: "WINDOWS", deviceType: .windows)]), NewDeviceData(sectionType: .deviceName, isOptional: true, deviceDatas: [(title: nil, deviceType : nil)])]
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        setupCollectionView()
        setupNav()
    }
    
    func setupCollectionView() {
        collectionView?.allowsMultipleSelection = true
        collectionView?.backgroundColor = UIColor(red: 249/255, green: 252/255, blue: 254/255, alpha: 1)
        collectionView?.register(NewDeviceCell.self, forCellWithReuseIdentifier: "NewDeviceCell")
        collectionView?.register(NewDeviceNameCell.self, forCellWithReuseIdentifier: "NewDeviceNameCell")
        collectionView?.register(NewDeviceSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NewDeviceSectionHeader")
        
        let horizontalInset = view.isSmallScreenSize == true ? horizontalSpacing : collectionView!.bounds.size.width * 0.12
        collectionView.contentInset = .init(top: view.getCorrectSize(40, 40, 72), left: horizontalInset, bottom: 50, right: horizontalInset)

    }
    
    func setupNav() {
        let leftButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Localization.shared.cancel.uppercased(), style: .plain, target: self, action: #selector(closeViewController))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(leftButtonAttributes, for: UIControl.State.highlighted)
        let rightButtonAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor : UIColor(red: 0/255, green: 163/255, blue: 218/255, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Muli-ExtraBold", size: 13)!
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Localization.shared.save.uppercased(), style: .plain, target: self, action: #selector(addDevice))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(rightButtonAttributes, for: .highlighted)

        let titleLabel = UILabel()
        titleLabel.text = Localization.shared.add_device
        titleLabel.font = UIFont(name: "Muli-Regular", size: 17)
        titleLabel.textColor = UIColor(red: 28/255, green: 41/255, blue: 51/255, alpha: 1)
        self.navigationItem.titleView = titleLabel
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController!.navigationBar.barStyle = .default
    }

    @objc func closeViewController() {
        self.dismiss(animated: true, completion: nil)
    }
 
    @objc func addDevice() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        var device : Int?
        var os : Int?
        let index = newDeviceDatas.firstIndex(where: { $0.sectionType == .deviceName })
        let name : String? = (self.collectionView?.cellForItem(at: IndexPath(item: 0, section: index ?? 2)) as? NewDeviceNameCell)?.nameTextField.text
        
        for i in self.collectionView?.indexPathsForSelectedItems ?? [] {
            if i.section == 0 { device = i.item } else if i.section == 1 { os = i.item }
        }
        
        output.addNewDevice(deviceType: device, osType: os, name: name)
    }
}




// MARK: UICollectionViewDataSource
extension AddNewDeviceCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return newDeviceDatas.count }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return newDeviceDatas[section].deviceDatas.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = newDeviceDatas[indexPath.section]
        if data.sectionType == .deviceName {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewDeviceNameCell", for: indexPath) as! NewDeviceNameCell
            cell.nameTextField.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewDeviceCell", for: indexPath) as! NewDeviceCell
            cell.data = data.deviceDatas[indexPath.item]
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NewDeviceSectionHeader", for: indexPath) as! NewDeviceSectionHeader
        header.titleLabel.text = newDeviceDatas[indexPath.section].sectionType.localized()
        header.addOptional(with: newDeviceDatas[indexPath.section].isOptional)
        header.titleLabel.sizeToFit()
        header.titleLabel.layoutIfNeeded()
        return header
    }
    
}

extension AddNewDeviceCollectionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ((textField.text?.count ?? 0) >= 32 && range.length == 0) == true ? false : true
    }
}




// MARK: UICollectionViewDelegateFlowLayout
extension AddNewDeviceCollectionViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = newDeviceDatas[indexPath.section]
        let correctCollectionViewWidth = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        switch data.sectionType {
        case .deviceType:
            let height : CGFloat = view.getCorrectSize(95, 100, 120)
            return CGSize(width: (correctCollectionViewWidth / 3) - horizontalSpacing * view.getCorrectSize(1.4, 2, 2), height: height)
        case .osType:
            let height : CGFloat = view.getCorrectSize(95, 100, 120)
            return CGSize(width: (correctCollectionViewWidth / 3) - horizontalSpacing * view.getCorrectSize(1.4, 2, 2), height: height)
        case .deviceName:
            return CGSize(width: (correctCollectionViewWidth), height: view.getCorrectSize(50, 50, 72))
        }
    }
    
    func sectionInsets(section : Int) -> UIEdgeInsets {
        let data = newDeviceDatas[section]
        if data.sectionType == .deviceType || data.sectionType == .osType { return UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: view.getCorrectSize(35, 35, 44), right: horizontalSpacing) }
        else if data.sectionType == .deviceName { return UIEdgeInsets(top: 0, left: 0, bottom: 35, right: 0) }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets(section : section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - horizontalSpacing * 2, height: view.getCorrectSize(30, 30, 42))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.getCorrectSize(15, 10, 15)
    }

}





// MARK: UICollectionViewDelagate
extension AddNewDeviceCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedRows = self.collectionView?.indexPathsForSelectedItems else { return }
        for selectedRow in selectedRows {
            if (selectedRow.section == indexPath.section) && (selectedRow.row != indexPath.row) {
                self.collectionView?.deselectItem(at: selectedRow, animated: false)
            }
        }
    }
}





extension AddNewDeviceCollectionViewController : NewDevicePresenterOutput {
    
    func displayNewDeviceAppNotice() {
        self.presentSimpleOKError(withTitle: Localization.shared.new_device_use_app_header, andSubtitle: Localization.shared.new_device_use_app_subheader, completion: {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })
    }
    
    func displayError(viewModel: ErrorViewModel) {
        let errorString = viewModel.errorText == nil ? Localization.shared.server_error : viewModel.errorText!.joined(separator: ". ")
        self.presentSimpleOKError(withTitle: Localization.shared.error_occured, andSubtitle: errorString, completion: {})
    }
    
    func newDeviceAddedSuccessfully(with data: DeviceDataViewModel) {
        self.dismiss(animated: true) {
            self.input?.newDeviceCreated(with: data)
        }
    }
    
    func displayUpgradePlanErrorPopup() {
        func presentCenterPopup() {
            let popup = CenterPopupViewController(icon: #imageLiteral(resourceName: "error_popup_logo"), title: Localization.shared.can_t_add_device, subtitle: Localization.shared.add_an_error_occured_while_trying_to_add_a_new_device_)
            popup.modalPresentationStyle = .custom
            popup.transitioningDelegate = popup.animator
            self.present(popup, animated: true, completion: nil)
        }
        
        presentCenterPopup()
        self.navigationItem.rightBarButtonItem?.isEnabled = true

    }
    
    func displayNoDataSetPopup() {
        self.presentSimpleOKError(withTitle: Localization.shared.add_please_select_required_fields, andSubtitle: Localization.shared.add_please_check_if_device_type_and_os_type_is_set_and, completion: {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        })
    }
    
    func displayLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
    }
}
