//
//  DevicesStore.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - DevicesStoreError

/// _DevicesStoreError_ is an enumeration for artist store errors
///
/// - generic:         Generic error
/// - invalidURL:      Invalid URL error
/// - invalidResponse: Invalid response
enum DevicesStoreError: Error {
    case generic
    case invalidURL
    case invalidResponse
}


// MARK: - DevicesStoreProtocol

/// _DevicesStoreProtocol_ is a protocol  for artist store behaviors
protocol DevicesStoreProtocol {
    
    /// Fetches devices from a store (API, memory, etc)
    ///
    /// - parameter completion: The completion block
    func fetchDevices(completion: @escaping ([DeviceData]?, Error?, Bool, Bool) -> ())
    
    /// Fetches devices from a store (API, memory, etc)
    ///
    /// - parameter uuid: Devices unique id 
    /// - parameter completion: The completion block
    func deleteDevice(with uuid : String, completion: @escaping (Bool, Error?, Bool) -> ())
        
}
