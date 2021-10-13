//
//  ToDoStoreProtocol.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - ToDoStoreProtocol

/// _ToDoStoreProtocol_ is a protocol  for artist store behaviors
protocol ToDoStoreProtocol {
    
    /// Fetches To Do tasks from a store (API, memory, etc)
    ///
    /// - parameter page: Page number
    /// - parameter completion: The completion block
    func fetchToDoTasks(page: Int, completion: @escaping ([TaskData]?, Error?, Int, Bool, Bool) -> ())
    
    /// Changes  a To Do status
    ///
    /// - parameter completion: The completion block
    func changeTaskStatus(forTaskUuid uuid : String, andStatus status : TaskStatus, completion: @escaping (Bool, Error?, Bool) -> ())
    
    /// Filters To Do tasks
    ///
    /// - parameter page: Page number
    /// - parameter completion: The completion block
    func filterToDoTasks(at page : Int, with priorityStringArray : [String], statusStringArray : [String], deviceUuidArray : [String], completion: @escaping ([TaskData]?, Error?, Bool, Bool) -> ())
    
    /// Sets a reminder for a To Do task
    ///
    /// - parameter uuid: Task's unique id
    /// - parameter durationString: Reminder duration string
    /// - parameter completion: The completion block
    func setReminderForTask(with uuid : String, durationString : String, completion: @escaping (Bool, Error?, Bool) -> ()) 

}
