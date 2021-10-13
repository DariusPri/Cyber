//
//  NewDeviceInteractor.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - NewDeviceInteractorInput

/// _NewDeviceInteractorInput_ is a protocol for interactor input behaviours
protocol NewDeviceInteractorInput: NewDeviceViewControllerOutput {
    
}


// MARK: - NewDeviceInteractorOutput

/// _NewDeviceInteractorOutput_ is a protocol for interactor output behaviours
protocol NewDeviceInteractorOutput {
    
    /// Tells the output to take action after successfull new device request
    ///
    func newDeviceSavedSuccessfully(with data : DeviceData)
    
    /// Tells the output to present an error
    ///
    /// - parameter error: The error to present
    func presentError(error: Error)
    
    /// Tells the output to present an error due to form being submited without any selection
    func dataNotSelected()
    
    /// Tells the output to present an error
    func presentUpgradePlanErrorPopup()
    
    /// Tells the output to present an error due to bad token
    func presentLogoutDueToBadToken()
    
    /// Tells the output to present an error due to currently unsupported devices to work from email link
    func presentNewDeviceAppNotice()
}


// MARK: - NewDeviceInteractor

/// _NewDeviceInteractor_ is an interactor responsible for artist details business logic
final class NewDeviceInteractor: NewDeviceInteractorInput {
    
    let output: NewDeviceInteractorOutput
    let worker: NewDeviceWorker
    
    var deviceData: DeviceData?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of _NewDeviceInteractor_ with an output and a worker
    ///
    /// - parameter output: The interactors output
    /// - parameter worker: The devices worker used to fetch devices
    ///
    /// - returns: An instance of _NewDeviceInteractor_
    init(output: NewDeviceInteractorOutput, worker: NewDeviceWorker = NewDeviceWorker()) {
        
        self.output = output
        self.worker = worker
    }
    
    
    // MARK: - Business logic
    
    func addNewDevice(deviceType: Int?, osType: Int?, name: String?) {
        
        guard let deviceType = deviceType, let osType = osType else { self.output.dataNotSelected(); return }
        
        var deviceTypeString : String = ""
        
        switch deviceType {
        case 0:
            deviceTypeString = "phone"
        case 1:
            deviceTypeString = "tablet"
        case 2:
            deviceTypeString = "pc"
        case 3:
            deviceTypeString = "pc"
        default:
            deviceTypeString = "smart-phone"
        }
        
        var osTypeString : String = ""
        
        switch osType {
        case 0:
            if deviceType == 0 || deviceType == 1 { osTypeString = "ios" }
            else if deviceType == 2 { osTypeString = "macosx" }
        case 1:
            osTypeString = "android"
        case 2:
            osTypeString = "windows"
        default:
            osTypeString = "ios"
        }
        
        if ((osTypeString == "ios") && (deviceTypeString != "macosx")) || ((osTypeString == "android") && (deviceTypeString != "windows")) {
            self.output.presentNewDeviceAppNotice()
            return
        }

//        if (osTypeString == "android" || osTypeString == "ios") || (deviceTypeString == "phone" || deviceTypeString == "tablet" || deviceTypeString == "smart-phone") {
//            self.output.presentNewDeviceAppNotice()
//            return
//        }
        
        worker.addNewDevice(deviceTypeString: deviceTypeString, osTypeString: osTypeString, name: name) { (data, error, isTokenValid) in
            if let error = error {
                self.output.presentError(error: error)
            } else if let data = data {
                self.output.newDeviceSavedSuccessfully(with: data)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                   if success == true {
                       self.addNewDevice(deviceType: deviceType, osType: osType, name: name)
                   } else {
                       self.output.presentLogoutDueToBadToken()
                   }
               })
            } else {
                self.output.presentUpgradePlanErrorPopup()
            }
        }
    }
    
    
}
