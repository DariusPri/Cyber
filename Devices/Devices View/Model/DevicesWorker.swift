//
//  DevicesWorker.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - DevicesWorker

/// _DevicesWorker_ is a worker object responsible to fetch artists from a store
class DevicesWorker {
    
    fileprivate var store: DevicesStoreProtocol
    
    
    // MARK: - Initializers
    
    /// Initializes an _DevicesWorker_ with a store
    ///
    /// - parameter store: A store where to fetch artists from (API, memory, etc)
    ///
    /// - returns: The instance of _DevicesWorker_
    init(store: DevicesStoreProtocol = DevicesAPIStore()) {
        self.store = store
    }
    
    
    // MARK: - Business Logic
    
    /// Fetches devices from a store
    ///
    /// - parameter completion: The completion block
    func fetchDevices(completion: @escaping ([DeviceData]?, Error?, Bool, Bool) -> ()) {
        store.fetchDevices(completion: completion)
    }
    
    /// Deletes device from a store
    ///
    /// - parameter completion: The completion block
    func deleteDevice(with uuid : String, completion : @escaping ((Bool, Error?, Bool) -> ())) {
        store.deleteDevice(with: uuid, completion: completion)
    }

}

