//
//  ToDoRouter.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit


// MARK: - ToDoRouterProtocol

/// _ToDoRouterProtocol_ is a protocol for router input behaviours
protocol ToDoRouterProtocol {
    
    var viewController: ToDoCollectionViewController? { get }
    
    /// Handles the navigation to How To task
    ///
    /// - parameter index: The selected task index
    func navigateToToDo(index : Int)
    
    /// Handles the navigation to demo popup
    func navigateToDemoPopup()
}


// MARK: - ToDoRouter

/// _ToDoRouter_ is a class responsible for routing from _ToDoViewController_
final class ToDoRouter {
    
    weak var viewController: ToDoCollectionViewController?
    
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _ToDoRouter_
    ///
    /// - parameter viewController: The _ToDoCollectionViewController_ to route from
    ///
    /// - returns: The instance of _ToDoRouter_
    init(viewController: ToDoCollectionViewController) {
        
        self.viewController = viewController
    }
}

// MARK: - ToDoRouterProtocol

extension ToDoRouter: ToDoRouterProtocol {
    
    /// Handles the navigation to How To view
    ///
    /// - parameter index: The selected task's index
    func navigateToToDo(index: Int) {
        let howToPopupViewController = HowToPopupViewController(taskData: viewController?.output.taskDatas![index])
        howToPopupViewController.todoInputDelegate = viewController
        howToPopupViewController.modalPresentationStyle = .overCurrentContext
        howToPopupViewController.transitioningDelegate = howToPopupViewController
        howToPopupViewController.popupCloseCompletion = {}
        viewController?.present(howToPopupViewController, animated: true, completion: nil)
    }

    /// Handles the navigation to demo popup
    func navigateToDemoPopup() {
        let newDeviceVC = TrialEndedCollectionViewController()
        let newDeviceNavVC = UINavigationController(rootViewController: newDeviceVC)
        viewController?.present(newDeviceNavVC, animated: true, completion: nil)
    }
    
    
}
