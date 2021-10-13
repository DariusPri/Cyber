//
//  ToDoViewModel.swift
//  Xpert
//
//  Created by Darius on 25/02/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - Task Data Model

struct TaskData {
    var uuid : String 
    var name : String
    var priority : TaskPriority
    var status : TaskStatus
    var device : Device
    var dueTime : Int?
    var reminderTime : Int?
    var isEnabled : Bool
}


// MARK: - ToDoDataViewModel

struct ToDoDataViewModel {
    var name : String
    var priority : TaskPriority
    var status : TaskStatus
    var device : Device
    var dueTime : Int?
    var reminderTime : Int?
    var isEnabled : Bool
}


