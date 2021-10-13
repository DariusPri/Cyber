//
//  DataRouter.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation



// MARK: - DevicesRouterProtocol

/// _DevicesRouterProtocol_ is a protocol for router input behaviours
protocol DataRouterProtocol {
    var viewController: DataCollectionViewController? { get }
}


// MARK: - DevicesRouter

/// _DataRouter_ is a class responsible for routing from _EmailsViewController_
final class DataRouter {
    
    weak var viewController: DataCollectionViewController?
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _DataRouter_
    ///
    /// - parameter viewController: The _EmailsCollectionViewController_ to route from
    ///
    /// - returns: The instance of _DevicesRouter_
    init(viewController: DataCollectionViewController) {
        self.viewController = viewController
    }
}

// MARK: - DevicesRouterProtocol

extension DataRouter: DataRouterProtocol {
    
}
