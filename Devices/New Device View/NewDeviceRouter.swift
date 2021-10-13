//
//  NewDeviceRouter.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - NewDeviceRouterProtocol

/// _NewDeviceRouterProtocol_ is a protocol for router input behaviours
protocol NewDeviceRouterProtocol {
    
    var viewController: AddNewDeviceCollectionViewController? { get }
    
    /// go back to DevicesViewController
    ///
    func navigateBackToDevicesViewController()
}


// MARK: - NewDeviceRouter

/// _NewDeviceRouter_ is a class responsible for routing from _ArtistViewController_
final class NewDeviceRouter {
    
    weak var viewController: AddNewDeviceCollectionViewController?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _NewDeviceRouter_
    ///
    /// - parameter viewController: The _AddNewDeviceCollectionViewController_ to route from
    ///
    /// - returns: The instance of _NewDeviceRouter_
    init(viewController: AddNewDeviceCollectionViewController) {
        self.viewController = viewController
    }
}

// MARK: - DevicesRouterProtocol

extension NewDeviceRouter: NewDeviceRouterProtocol {
    
    /// Handles going back to the main devices view
    func navigateBackToDevicesViewController() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }

}
