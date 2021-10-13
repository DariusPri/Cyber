//
//  ToDoConfigurator.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation

// MARK: - ToDoConfigurator

/// _ToDoConfigurator_ is a class responsible for configuring the VIP scene pathways for _ToDoCollectionViewController_
final class ToDoConfigurator {
    
    /// Singleton instance of _ToDoConfigurator_
    static let sharedInstance = ToDoConfigurator()
    
    
    // MARK: - Configuration
    
    /// Configures the VIP scene with pathways between router, view controller, interactor and presenter
    ///
    /// - parameter viewController: The view controller
    func configure(viewController: ToDoCollectionViewController) {
        
        let router = ToDoRouter(viewController: viewController)
        let presenter = ToDoPresenter(output: viewController)
        let interactor = ToDoInteractor(output: presenter)
        
        viewController.output = interactor
        viewController.router = router
    }
}
