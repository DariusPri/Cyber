//
//  DevicesRouter.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


// MARK: - DevicesRouterProtocol

/// _DevicesRouterProtocol_ is a protocol for router input behaviours
protocol DevicesRouterProtocol {
    
    var viewController: DevicesCollectionViewController? { get }
    
    /// Handles the device activation view when selecting activate in the device list
    ///
    /// - parameter indexPath: The selected index path
    func navigateToDeviceActivation(with deviceData: DeviceData)
    
    /// Shows view to add new device
    ///
    func navigateToNewDevice()
}


// MARK: - DevicesRouter

/// _DevicesRouter_ is a class responsible for routing from _ArtistViewController_
final class DevicesRouter {
    
    weak var viewController: DevicesCollectionViewController?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _DevicesRouter_
    ///
    /// - parameter viewController: The _DevicesCollectionViewController_ to route from
    ///
    /// - returns: The instance of _DevicesRouter_
    init(viewController: DevicesCollectionViewController) {
        self.viewController = viewController
    }
}

// MARK: - DevicesRouterProtocol

extension DevicesRouter: DevicesRouterProtocol {
    
    /// Shows view to add new device
    ///
    func navigateToNewDevice() {
        let newDeviceVC = AddNewDeviceCollectionViewController()
        let newDeviceNavVC = UINavigationController(rootViewController: newDeviceVC)
        newDeviceVC.input = viewController
        viewController?.present(newDeviceNavVC, animated: true, completion: nil)
    }
    
    /// Handles the device activation view when selecting activate in the device list
    ///
    /// - parameter deviceData: Device data model
    func navigateToDeviceActivation(with deviceData: DeviceData) {
        let activateDeviceVC = DeviceActivationViewController(deviceData: deviceData)
        activateDeviceVC.deviceActivationDelegate = viewController
        let activateDeviceNavVC = UINavigationController(rootViewController: activateDeviceVC)
        viewController?.present(activateDeviceNavVC, animated: true, completion: nil)
    }
    
}
