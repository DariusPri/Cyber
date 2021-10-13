//
//  ToDoWorker.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - ToDoWorker

/// _ToDoWorker_ is a worker object responsible to fetch artists from a store
class ToDoWorker {
    
    fileprivate var store: ToDoStoreProtocol
    
    
    // MARK: - Initializers
    
    /// Initializes an _ToDoWorker_ with a store
    ///
    /// - parameter store: A store where to fetch artists from (API, memory, etc)
    ///
    /// - returns: The instance of _ToDoWorker_
    init(store: ToDoStoreProtocol = ToDoAPIStore()) {
        self.store = store
    }
    
    
    // MARK: - Business Logic
    
    /// Fetches To Dos from a store
    ///
    /// - parameter completion: The completion block
    func fetchToDos(page: Int, completion: @escaping ([TaskData]?, Error?, Int, Bool, Bool) -> ()) {
        store.fetchToDoTasks(page: page, completion: completion)
    }
    
    /// Changes a To Do status
    ///
    /// - parameter uuid: The To Do's unique id
    /// - parameter status: new status to change task to
    /// - parameter completion: The completion block
    func changeTaskStatus(forTaskUuid uuid: String, andStatus status : TaskStatus, completion : @escaping ((Bool, Error?, Bool) -> ())) {
        store.changeTaskStatus(forTaskUuid: uuid, andStatus: status, completion: completion)
    }
    
    /// Filters  To Do tasks
    ///
    /// - parameter page: page number
    /// - parameter priorityStringArray: selected priority filter array
    /// - parameter statusStringArray: selected status filter array
    /// - parameter deviceUuidArray: selected device ids array
    /// - parameter completion: The completion block
    func filterToDoTasks(at page : Int, with priorityStringArray : [String], statusStringArray : [String], deviceUuidArray : [String], completion: @escaping ([TaskData]?, Error?, Bool, Bool) -> ()) {
        store.filterToDoTasks(at: page, with: priorityStringArray, statusStringArray: statusStringArray, deviceUuidArray: deviceUuidArray, completion: completion)
    }
    
    /// Sets a reminder for a To Do
    ///
    /// - parameter uuid: The To Do's unique id
    /// - parameter durationString: The reminder duration string
    /// - parameter completion: The completion block
    func setReminderForTask(with uuid : String, durationString : String, completion: @escaping (Bool, Error?, Bool) -> ()) {
        store.setReminderForTask(with: uuid, durationString: durationString, completion: completion)
    }
    
}

