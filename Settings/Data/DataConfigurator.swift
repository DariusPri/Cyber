//
//  DataConfigurator.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - DataConfigurator

/// _DataConfigurator_ is a class responsible for configuring the VIP scene pathways for _DataCollectionViewController_
final class DataConfigurator {
    
    /// Singleton instance of _DataConfigurator_
    static let sharedInstance = DataConfigurator()
    
    
    // MARK: - Configuration
    
    /// Configures the VIP scene with pathways between router, view controller, interactor and presenter
    ///
    /// - parameter viewController: The view controller
    func configure(viewController: DataCollectionViewController) {
        
        let router = DataRouter(viewController: viewController)
        let presenter = DataPresenter(output: viewController)
        let interactor = DataInteractor(output: presenter)
        
        viewController.output = interactor
        viewController.router = router
    }
}
