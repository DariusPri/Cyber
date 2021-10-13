//
//  DevicesInteractor.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation



// MARK: - DevicesInteractorInput

/// _DevicesInteractorInput_ is a protocol for interactor input behaviours
protocol DevicesInteractorInput: DevicesViewControllerOutput {
    
}


// MARK: - DevicesInteractorOutput

/// _DevicesInteractorOutput_ is a protocol for interactor output behaviours
protocol DevicesInteractorOutput {
    
    /// Tells the output to present devices
    ///
    /// - parameter deviceDatas: The list of devices to present
    func presentDevices(deviceDatas: [DeviceData])
    
    /// Tells the output to present an error
    ///
    /// - parameter error: The error to present
    func presentError(error: Error)
    
    /// Tells the output to present logout due to bad token
    func presentLogoutDueToBadToken()
    
    /// Tells the output to present successfuly deleted device
    func presentSuccessfulDeletedDevice()
    
    /// Tells the output to present an error
    ///
    /// - parameter deviceData: The devices data to present
    func activateDevice(deviceData: DeviceData)
    
}


// MARK: - DevicesInteractor

/// _DevicesInteractor_ is an interactor responsible for artist details business logic
final class DevicesInteractor: DevicesInteractorInput {
    
    let output: DevicesInteractorOutput
    let worker: DevicesWorker
    
    var deviceDatas: [DeviceData]?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of _DevicesInteractor_ with an output and a worker
    ///
    /// - parameter output: The interactors output
    /// - parameter worker: The devices worker used to fetch devices
    ///
    /// - returns: An instance of _ArtistInteractor_
    init(output: DevicesInteractorOutput, worker: DevicesWorker = DevicesWorker()) {
        
        self.output = output
        self.worker = worker
    }
    
    
    // MARK: - Business logic
    
    /// Fetches a list of user saved devices through the worker
    func fetchDeviceDatas() {
        
        var currentPage = 0
        let savedTimes = self.deviceDatas?.filter({ $0.lastSentActivation != nil })
        self.deviceDatas = []
        
        func resetLastActivationTimes() {
            for deviceData in (savedTimes ?? []) {
                if let index = self.deviceDatas!.firstIndex(where: { $0.uuid == deviceData.uuid }) {
                    self.deviceDatas?[index].lastSentActivation = deviceData.lastSentActivation
                }
            }
        }
        
        func fetchDevicesAt(page : Int) {
            worker.fetchDevices { (deviceDatas, error, isTokenValid, hasMorePages) in
                if let error = error {
                    self.output.presentError(error: error)
                } else if let deviceDatasArray = deviceDatas {
                    
                    self.deviceDatas?.append(contentsOf: deviceDatasArray)
                    resetLastActivationTimes()
                    
                    if hasMorePages == true {
                        currentPage += 1
                        fetchDevicesAt(page: currentPage)
                    } else {
                        self.output.presentDevices(deviceDatas: self.deviceDatas ?? [])
                    }
                } else if isTokenValid == false {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.fetchDeviceDatas()
                        } else {
                            self.output.presentLogoutDueToBadToken()
                        }
                    })
                }
            }
        }
        fetchDevicesAt(page: currentPage)
    }
    
    func deleteDevice(with uuid : String) {
        
        let uuid = uuid
        
        worker.deleteDevice(with: uuid) { (success, error, isTokenValid) in

            if success == true {
                self.output.presentSuccessfulDeletedDevice()
            } else if let e = error {
                self.output.presentError(error: e)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.deleteDevice(with: uuid)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    
    func activateDevice(at indexPath : IndexPath) {
        if let deviceData = self.deviceDatas?[indexPath.item] {
            self.output.activateDevice(deviceData: deviceData)
        } else {
            self.output.presentError(error: NetworkError.generic)
        }
    }
    
    func setActivationEmailTimerForDevice(at indexPath: IndexPath) {
        self.deviceDatas?[indexPath.item].lastSentActivation = Date().timeIntervalSince1970.advanced(by: 5 * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + (5 * 60) + 5) {
            self.output.presentDevices(deviceDatas: self.deviceDatas ?? [])
        }
        self.output.presentDevices(deviceDatas: self.deviceDatas ?? [])
    }
}
