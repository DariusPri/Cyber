//
//  NewDeviceConfigurator.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - NewDeviceConfigurator

/// _NewDeviceConfigurator_ is a class responsible for configuring the VIP scene pathways for _AddNewDeviceCollectionViewController_
final class NewDeviceConfigurator {
    
    /// Singleton instance of _DevicesConfigurator_
    static let sharedInstance = NewDeviceConfigurator()
    
    
    // MARK: - Configuration
    
    /// Configures the VIP scene with pathways between router, view controller, interactor and presenter
    ///
    /// - parameter viewController: The view controller
    func configure(viewController: AddNewDeviceCollectionViewController) {
        
        let router = NewDeviceRouter(viewController: viewController)
        let presenter = NewDevicePresenter(output: viewController)
        let interactor = NewDeviceInteractor(output: presenter)
        
        viewController.output = interactor
        viewController.router = router
    }
}
