//
//  NewDeviceWorker.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - NewDeviceWorker

/// _NewDeviceWorker_ is a worker object responsible to fetch artists from a store
class NewDeviceWorker {
    
    fileprivate var store: NewDeviceStoreProtocol
    
    // MARK: - Initializers
    
    /// Initializes an _NewDeviceWorker_ with a store
    ///
    /// - parameter store: A store where to fetch artists from (API, memory, etc)
    ///
    /// - returns: The instance of _NewDeviceWorker_
    init(store: NewDeviceStoreProtocol = NewDeviceAPIStore()) {
        self.store = store
    }
    
    // MARK: - Business Logic
    
    /// Saves device to the backend
    ///
    /// - parameter completion: The completion block
    func addNewDevice(deviceTypeString: String, osTypeString: String, name: String?, completion: @escaping (DeviceData?, Error?, Bool) -> ()) {
        store.addNewDevice(deviceTypeString: deviceTypeString, osTypeString: osTypeString, name: name, completion: completion)
    }
    
}

