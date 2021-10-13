//
//  ToDoPresenter.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - ToDoPresenterInput

/// _ToDoPresenterInput_ is a protocol for presenter input behaviours
protocol ToDoPresenterInput: ToDoInteractorOutput {
    
}


// MARK: - ToDoPresenterOutput

/// _ToDoPresenterOutput_ is a protocol for presenter output behaviours
protocol ToDoPresenterOutput: AnyObject {
    
    /// Tells the output to display tasks
    ///
    /// - parameter viewModels: The To Do view models
    func displayToDo(viewModels: [ToDoDataViewModel])
    
    /// Tells the output to dislpay an error
    ///
    /// - parameter viewModel: The error view model
    func displayError(viewModel: ErrorViewModel)
    
    /// Tells the output to dislpay a successful reload task
    ///
    /// - parameter index: Task's index
    /// - parameter viewModels: The To Do data view models
    func displaySuccessfulReloadTask(at index : Int, withModels viewModels: [ToDoDataViewModel])
    
    /// Tells the output to dislpay an error
    ///
    /// - parameter index: Task's index
    func displayToDoPopup(at index: Int)
    
    /// Tells the output to dislpay a demo popup
    func displayDemoPopup()
    
    /// Tells the output to logout user due to a bad token
    func displayLogoutDueToBadToken()
    
}


// MARK: - ToDoPresenter

/// _ToDoPresenter_ is a class responsible for presenting ToDo logic
final class ToDoPresenter {
    
    private(set) weak var output: ToDoPresenterOutput?
    
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _ToDoPresenter_ with an output object
    ///
    /// - parameter output: The output that conforms to protocol _ToDoPresenterOutput_
    ///
    /// - returns: The instance of _ToDoPresenter_
    init(output: ToDoPresenterOutput) {
        self.output = output
    }
}


// MARK: - ToDoPresenterInput

extension ToDoPresenter: ToDoPresenterInput {
    
    /// Prepares the task models for presentation and tells the output to display To Do tasks
    ///
    /// - parameter taskDatas: The list of task datas
    func presentToDo(taskDatas: [TaskData]) {
        let viewModels = taskDatas.compactMap { task -> ToDoDataViewModel in
            return ToDoDataViewModel(name: task.name, priority: task.priority, status: task.status, device: task.device, dueTime: task.dueTime, reminderTime: task.reminderTime, isEnabled: task.isEnabled)
        }
        output?.displayToDo(viewModels: viewModels)
    }
    
    /// Prepares the error model for presentation and tells the output to display error
    ///
    /// - parameter error: The error
    func presentError(viewModel: ErrorViewModel) {
        output?.displayError(viewModel: viewModel)
    }
    
    
    /// Tells the output to display successfuly deleted task info
    ///
    /// - parameter index: Tasks index
    /// - parameter taskDatas: Task datas
    func presentSuccessfulReloadTask(at index: Int, and taskDatas: [TaskData]) {
        let viewModels = taskDatas.compactMap { task -> ToDoDataViewModel in
            return ToDoDataViewModel(name: task.name, priority: task.priority, status: task.status, device: task.device, dueTime: task.dueTime, reminderTime: task.reminderTime, isEnabled: task.isEnabled)
        }
        output?.displaySuccessfulReloadTask(at: index, withModels: viewModels)
    }
    
    /// Tells the output to display a How to detailed task
    ///
    /// - parameter index: Tasks index
    func presentToDoPopup(at index: Int) {
        output?.displayToDoPopup(at: index)
    }
    
    /// Tells the output to display demo popup
    func presentDemoViewPopup() {
        output?.displayDemoPopup()
    }
    
    
    /// Tells the output to display logout due to a bad token
    func presentLogoutDueToBadToken() {
        output?.displayLogoutDueToBadToken()
    }
    
}
