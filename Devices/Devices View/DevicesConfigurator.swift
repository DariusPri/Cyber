//
//  DevicesConfigurator.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - DevicesConfigurator

/// _DevicesConfigurator_ is a class responsible for configuring the VIP scene pathways for _DevicesCollectionViewController_
final class DevicesConfigurator {
    
    /// Singleton instance of _DevicesConfigurator_
    static let sharedInstance = DevicesConfigurator()
    
    
    // MARK: - Configuration
    
    /// Configures the VIP scene with pathways between router, view controller, interactor and presenter
    ///
    /// - parameter viewController: The view controller
    func configure(viewController: DevicesCollectionViewController) {
        
        let router = DevicesRouter(viewController: viewController)
        let presenter = DevicesPresenter(output: viewController)
        let interactor = DevicesInteractor(output: presenter)
        
        viewController.output = interactor
        viewController.router = router
    }
}
