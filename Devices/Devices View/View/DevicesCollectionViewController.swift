//
//  DevicesCollectionViewController.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - DevicesViewControllerInput

/// _ArtistViewControllerInput_ is a protocol for view controller input behaviours
protocol DevicesViewControllerInput: DevicesPresenterOutput {
    
}


// MARK: - DevicesViewControllerOutput

/// _DevicesViewControllerInput_ is a protocol for view controller output behaviours
protocol DevicesViewControllerOutput {
    
    var deviceDatas: [DeviceData]? { get }
    
    
    /// Tells the output (interactor) to fetch albums for artist
    ///
    /// - parameter artistId: The artist identifier
    func fetchDeviceDatas()
    
    
    func deleteDevice(with uuid : String)
    
    func activateDevice(at indexPath : IndexPath)
    
    func setActivationEmailTimerForDevice(at indexPath : IndexPath)
    
}


// MARK: - ArtistViewController

/// _ArtistViewController_ is a view controller responsible for displaying artist details like a list of albums
class DevicesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ErrorPresenter {
    
    var output: DevicesViewControllerOutput!
    var router: DevicesRouterProtocol!
    
    fileprivate var deviceDataViewModels: [DeviceDataViewModel] = []

    var correctCollectionViewWidth : CGFloat = 300
    var selectDeviceWithUuid : String?
    
    // MARK: - Initializers
    
    /// Initializes an instance of _ArtistsViewController_ with a configurator
    ///
    /// - parameter configurator: The configurator
    ///
    /// - returns: The instance of _ArtistsViewController_
    init(configurator: DevicesConfigurator = DevicesConfigurator.sharedInstance) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        configure(configurator: configurator)
    }
    
    /// Initializes an instance of _ArtistsViewController_ from storyboard
    ///
    /// - parameter coder: The coder
    ///
    /// - returns: The instance of _ArtistsViewController_
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure(configurator: DevicesConfigurator.sharedInstance)
    }
    
    // MARK: - Configurator
    
    private func configure(configurator: DevicesConfigurator = DevicesConfigurator.sharedInstance) {
        configurator.configure(viewController: self)
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchDevices()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        collectionView?.backgroundColor = .clear
        self.collectionView!.register(InactiveDeviceCollectionViewCell.self, forCellWithReuseIdentifier: "InactiveDeviceCollectionViewCell")
        self.collectionView!.register(ActiveDeviceCollectionViewCell.self, forCellWithReuseIdentifier: "ActiveDeviceCollectionViewCell")
        self.collectionView!.register(NewDeviceCollectionViewCell.self, forCellWithReuseIdentifier: "NewDeviceCollectionViewCell")
        self.collectionView!.register(NoDataCollectionViewCell.self, forCellWithReuseIdentifier: "NoDataCollectionViewCell")
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = view.getCorrectSize(15, 15, 20)
        let horizontalInset : CGFloat = view.isSmallScreenSize == true ? 0 : (view.bounds.size.width - view.getCorrectSize(600, 600, 720)) / 2
        collectionView?.contentInset = .init(top: 0, left: horizontalInset, bottom: 50, right: horizontalInset)
        correctCollectionViewWidth = view.bounds.size.width - collectionView!.contentInset.left - collectionView!.contentInset.right
        self.collectionView?.alwaysBounceVertical = true
        
        if let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        self.collectionView.reloadData()
    }
    
    // MARK: - Event handling
    
    @objc func refreshDevices() {
        fetchDevices()
    }
    
    func fetchDevices() {
        output.fetchDeviceDatas()
    }
    
    @objc func activateDevice(sender : UIButton) {
        let i = sender.tag
        let data = deviceDataViewModels[i]
       
        if data.status == .inactive {
            let isThisDevice = data.fingerprint == UIDevice.current.identifierForVendor!.uuidString.sha512
            if isThisDevice == true {
                output.activateDevice(at: IndexPath(item: sender.tag, section: 0))
            } else {
                self.output.setActivationEmailTimerForDevice(at: IndexPath(item: sender.tag, section: 0))
                self.showSuccessPopup(title: Localization.shared.verification_is_resent.doubleBracketReplace(with: UserData.shared.email), subtitle: Localization.shared.we_sent_an_activation_email_subheader, selector: nil)
            }
        }
    }

    @objc func deleteDevice(sender : UIButton) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = sender
        alertVC.popoverPresentationController?.sourceRect = sender.bounds
        alertVC.addAction(UIAlertAction(title: Localization.shared.device_delete_device.capitalized, style: .destructive, handler: { (_) in
            let uuid = self.deviceDataViewModels[sender.tag].uuid
            self.output.deleteDevice(with: uuid)
        }))
        alertVC.addAction(UIAlertAction(title: Localization.shared.cancel.capitalized, style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func addDeviceButtonAction() {
        router.navigateToNewDevice()
    }

}

// MARK: UICollectionViewDataSource
extension DevicesCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return deviceDataViewModels.count + (deviceDataViewModels.count == 0 ? 2 : 1) }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewDeviceCollectionViewCell", for: indexPath) as! NewDeviceCollectionViewCell
            cell.containerWidthLayout?.constant = correctCollectionViewWidth - 30
            cell.addDeviceButton.addTarget(self, action: #selector(addDeviceButtonAction), for: .touchUpInside)
            return cell
        } else {
            
            if deviceDataViewModels.count == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoDataCollectionViewCell", for: indexPath) as! NoDataCollectionViewCell
                cell.widthConstraint?.constant = correctCollectionViewWidth
                cell.heightConstraint?.constant = (collectionView.bounds.size.height - collectionView.getCorrectSize(60, 60, 80))
                return cell
            }
            
            let data = deviceDataViewModels[indexPath.item-1]
            if data.status == .inactive {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InactiveDeviceCollectionViewCell", for: indexPath) as! InactiveDeviceCollectionViewCell
                cell.containerWidthLayout?.constant = correctCollectionViewWidth - 30
                cell.data = data
                cell.activateDeviceButton.tag = indexPath.item - 1
                cell.activateDeviceButton.addTarget(self, action: #selector(activateDevice(sender:)), for: .touchUpInside)
                cell.infoButton.tag = indexPath.item - 1
                cell.infoButton.addTarget(self, action: #selector(deleteDevice(sender:)), for: .touchUpInside)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActiveDeviceCollectionViewCell", for: indexPath) as! ActiveDeviceCollectionViewCell
                cell.containerWidthLayout?.constant = correctCollectionViewWidth - 30
                cell.data = data
                cell.infoButton.tag = indexPath.item - 1
                cell.infoButton.addTarget(self, action: #selector(deleteDevice(sender:)), for: .touchUpInside)
                return cell
            }
        }
    }
}


extension DevicesCollectionViewController : DevicesViewControllerInput {
    
}

extension DevicesCollectionViewController : DevicesPresenterOutput {
    
    func displayDevices(viewModels: [DeviceDataViewModel]) {
        deviceDataViewModels = viewModels
        self.collectionView?.reloadDataWithoutScroll()
        (self.parent as? DevicesViewController)?.updateDeviceCounter(count: viewModels.count)
        performCellSelectAnimationIfNeeded()
    }
    
    func performCellSelectAnimationIfNeeded() {
        if let uuid = selectDeviceWithUuid, let index = self.output.deviceDatas?.firstIndex(where: { $0.uuid == uuid }) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.collectionView.performBatchUpdates({
                    let rect = self.collectionView.layoutAttributesForItem(at: IndexPath(row: index+1, section: 0))?.frame
                    self.collectionView.scrollRectToVisible(rect!, animated: false)
                }) { (_) in
                    if let cell = self.collectionView.cellForItem(at: IndexPath(item: index+1, section: 0)) as? DeviceCollectionViewBaseCell {
                        UIView.animate(withDuration: 0.2, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.curveEaseIn], animations: {
                            cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        }) { (_) in
                            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
                                cell.transform = .identity
                            }) { (_) in
                                self.selectDeviceWithUuid = nil
                            }
                        }
                    }
                }
            }
        }
    }
    
    func displayError(viewModel: ErrorViewModel) {
        presentError(viewModel: viewModel)
    }
    
    
    func displaySuccessfulDeletedDevice() {
        fetchDevices()
    }
    
    func displayDeviceActivation(with deviceData: DeviceData) {
        router.navigateToDeviceActivation(with: deviceData)
    }
    
    func displayLogoutDueToBadToken() {
        DashboardViewController.logOutUserDueToBadToken()
    }
    
}



extension DevicesCollectionViewController : DeviceActivationProtocol {
    func activateDeviceAndAddAnotherDevice() {
        addDeviceButtonAction()
    }
    func activateDeviceAndGoToDoList() {
        (self.parent?.parent as? DashboardTabBarController)?.selectedIndex = 3
    }
    func activateDevice() {
        fetchDevices()
    }
    
}


extension DevicesCollectionViewController : NewDeviceViewControllerInput {

    func newDeviceCreated(with data: DeviceDataViewModel) {
        fetchDevices()
    }
    

}
