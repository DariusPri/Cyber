//
//  NewDeviceStoreProtocol.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - NewDeviceStoreProtocol

/// _NewDeviceStoreProtocol_ is a protocol  for artist store behaviors
protocol NewDeviceStoreProtocol {
    
    /// Adds a new device to a store
    ///
    /// - parameter completion: The completion block
    func addNewDevice(deviceTypeString: String, osTypeString: String, name: String?, completion: @escaping (DeviceData?, Error?, Bool) -> ())
    
}
