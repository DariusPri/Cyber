//
//  ToDoInteractor.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation



// MARK: - ToDoInteractorInput

/// _ToDoInteractorInput_ is a protocol for interactor input behaviours
protocol ToDoInteractorInput: ToDoViewControllerOutput {
    
}


// MARK: - ToDoInteractorOutput

/// _ToDoInteractorOutput_ is a protocol for interactor output behaviours
protocol ToDoInteractorOutput {
    
    /// Tells the output to present To Do
    ///
    /// - parameter taskDatas: The list of To Dos to present
    func presentToDo(taskDatas: [TaskData])
    
    /// Tells the output to present an error
    ///
    /// - parameter viewModel: The error to present
    func presentError(viewModel: ErrorViewModel)
    
    /// Tells the output to present successful reloaded task
    ///
    /// - parameter index: The index of a  task
    /// - parameter taskDatas: Task data models
    func presentSuccessfulReloadTask(at index: Int, and taskDatas : [TaskData])
    
    /// Tells the output to present a popup
    ///
    /// - parameter index: The error to present
    func presentToDoPopup(at index: Int)
    
    /// Tells the output to present a demo popup
    func presentDemoViewPopup()
    
    /// Tells the output to present a logout due to bad token
    func presentLogoutDueToBadToken()
}


// MARK: - ToDoInteractor

/// _ToDoInteractor_ is an interactor responsible for To do details business logic
final class ToDoInteractor: ToDoInteractorInput {
    
    let output: ToDoInteractorOutput
    let worker: ToDoWorker
    
    var taskDatas: [TaskData]?
    
    var filteredPirorityDataArray : [PriorityFilterData] = []
    var filteredStatusDataArray : [StatusFilterData] = []
    var filteredDeviceDataArray : [DeviceFilterData] = []
    
    var loadingTasks = false

    
    // MARK: - Initializers
    
    /// Initializes an instance of _ToDoInteractor_ with an output and a worker
    ///
    /// - parameter output: The interactors output
    /// - parameter worker: The ToDo worker used to fetch ToDo
    ///
    /// - returns: An instance of _ToDoInteractor_
    init(output: ToDoInteractorOutput, worker: ToDoWorker = ToDoWorker()) {
        self.output = output
        self.worker = worker
    }
    
    
    // MARK: - Business logic
        
    func fetchToDoTaskDatas() {
        if loadingTasks == true { return }
        loadingTasks = true
        
        var currentPage = 1
        self.taskDatas = []

        func fetchTasksAt(page : Int) {
            worker.fetchToDos(page: page) { (taskDatas, error, _, goodToken, hasMorePages) in
                if let error = error {
                    self.output.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error, error.localizedDescription]))
                    self.loadingTasks = false
                } else if let taskDataArray = taskDatas {
                    self.taskDatas?.append(contentsOf: taskDataArray)
                    if hasMorePages == true {
                        currentPage += 1
                        fetchTasksAt(page: currentPage)
                    } else {
                        self.taskDatas = self.taskDatas?.sorted(by: { (data1, data2) -> Bool in
                            if data1.status != .completed && data2.status == .completed { return true }
                            if data1.status != .postponed && data2.status == .postponed { return true }
                            return (data1.dueTime ?? 0) < (data2.dueTime ?? 0)
                        })
                        self.output.presentToDo(taskDatas: self.taskDatas ?? [])
                    }
                } else if goodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.fetchToDoTaskDatas()
                        } else {
                            self.output.presentLogoutDueToBadToken()
                            self.loadingTasks = false
                        }
                    })
                }
            }
        }
        
        fetchTasksAt(page: currentPage)
    }
    
    
    func filterTasks(with pirorityDataArray : [PriorityFilterData], statusDataArray : [StatusFilterData], deviceDataArray : [DeviceFilterData]) {
        if loadingTasks == true { return }
        loadingTasks = true
        
        if pirorityDataArray.count == 0 && statusDataArray.count == 0 && deviceDataArray.count == 0 { return }
        
        var currentPage = 1
        self.taskDatas = []
        
        self.filteredDeviceDataArray = deviceDataArray
        self.filteredStatusDataArray = statusDataArray
        self.filteredPirorityDataArray = pirorityDataArray
        
        let p = pirorityDataArray
        var s = statusDataArray
        let d = deviceDataArray
        
        if s.count == 1 {
            if s.first?.status == TaskStatus.toDo {
                s.append(StatusFilterData(status: TaskStatus.overdue, isSelected: false))
                s.append(StatusFilterData(status: TaskStatus.postponed, isSelected: false))
            }
        } else if s.count == 0 {
            s.append(.init(status: .toDo, isSelected: false))
            s.append(.init(status: .overdue, isSelected: false))
            s.append(.init(status: .postponed, isSelected: false))
        }
        
        let priorityStringArray = pirorityDataArray.map({ $0.priority.rawValue.lowercased() })
        let statusStringArray = s.map({ $0.status.toString() })
        let deviceUuidArray = deviceDataArray.map({ $0.device.uuid })
        

        func filterTasks(at page: Int) {
            self.worker.filterToDoTasks(at: page, with: priorityStringArray, statusStringArray: statusStringArray, deviceUuidArray: deviceUuidArray) { (taskDatas, error, goodToken, hasMorePages) in
                if let error = error {
                    self.output.presentError(viewModel: ErrorViewModel(errorText: [Localization.shared.server_error, error.localizedDescription]))
                    self.loadingTasks = false
                } else if let taskDatasArray = taskDatas {
                    if currentPage == 1 {
                        self.taskDatas = []
                    }
                    self.taskDatas?.append(contentsOf: taskDatasArray)
                    if hasMorePages == true {
                        currentPage += 1
                        filterTasks(at: currentPage)
                    } else {
                        self.output.presentToDo(taskDatas: self.taskDatas ?? [])
                    }
                } else if goodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.filterTasks(with: p, statusDataArray: s, deviceDataArray: d)
                        } else {
                            self.output.presentLogoutDueToBadToken()
                            self.loadingTasks = false
                        }
                    })
                }
            }
        }
        
        filterTasks(at: currentPage)
    
    }
    
    func tickCompletedTask(at index: Int) {
        let i = index
        if self.taskDatas![index].status == .completed { return  }
        let newStatus : TaskStatus = self.taskDatas![index].status == .completed ? .toDo : .completed
        let uuid = self.taskDatas![index].uuid

        self.worker.changeTaskStatus(forTaskUuid: uuid, andStatus: newStatus) { (success, error, goodToken) in
            DispatchQueue.main.async {
                if let errorString = error?.localizedDescription {
                    self.output.presentError(viewModel: ErrorViewModel.init(errorText: [Localization.shared.server_error, errorString]))
                }
                if success == true {
                    self.taskDatas![index].status = newStatus
                    self.output.presentSuccessfulReloadTask(at: index, and: self.taskDatas!)
                } else if goodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.tickCompletedTask(at: i)
                        } else {
                            self.output.presentLogoutDueToBadToken()
                        }
                    })
                }
            }
        }
    }
    
    
    func setTimerDuration(for days : Int, at index: Int) {
        
        let i = index
        let uuid = self.taskDatas![index].uuid
        var durationString = ""
        
        switch days {
        case 5:
            durationString = "five_days"
        case 14:
            durationString = "two_weeks"
        default:
            durationString = "one_day"
        }
        
        self.worker.setReminderForTask(with: uuid, durationString: durationString) { (success, error, goodToken) in
            DispatchQueue.main.async {
                if error != nil {
                    self.output.presentError(viewModel: ErrorViewModel.init(errorText: [Localization.shared.server_error]))
                }
                if success == true {
                    self.taskDatas![index].reminderTime = days
                    self.taskDatas![index].status = .postponed
                    //self.taskDatas![index].isEnabled = false
                    self.output.presentSuccessfulReloadTask(at: index, and: self.taskDatas!)
                } else if goodToken == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.tickCompletedTask(at: i)
                        } else {
                            self.output.presentLogoutDueToBadToken()
                        }
                    })
                }
            }
        }
    }
    
    func cancelTimerDuration(at index: Int) {
        self.taskDatas![index].reminderTime = nil
        self.taskDatas![index].status = .toDo
        self.output.presentSuccessfulReloadTask(at: index, and: self.taskDatas!)
    }
    
    func showToDoIfNeeded(for index : Int) {
        if self.taskDatas![index].isEnabled == true {
            self.output.presentToDoPopup(at: index)
        } else {
            self.output.presentDemoViewPopup()
        }
    }
}
