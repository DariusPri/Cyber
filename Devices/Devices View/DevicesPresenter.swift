//
//  DevicesPresenter.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - DevicesPresenterInput

/// _DevicesPresenterInput_ is a protocol for presenter input behaviours
protocol DevicesPresenterInput: DevicesInteractorOutput {
    
}


// MARK: - DevicesPresenterOutput

/// _DevicesPresenterOutput_ is a protocol for presenter output behaviours
protocol DevicesPresenterOutput: AnyObject {
    
    /// Tells the output to display albums
    ///
    /// - parameter viewModels: The devices view models
    func displayDevices(viewModels: [DeviceDataViewModel])
    
    /// Tells the output to dislpay an error
    ///
    /// - parameter viewModel: The error view model
    func displayError(viewModel: ErrorViewModel)
    
    
    func displaySuccessfulDeletedDevice()
    
    func displayDeviceActivation(with deviceData : DeviceData)
    
    func displayLogoutDueToBadToken() 

}


// MARK: - DevicesPresenter

/// _DevicesPresenter_ is a class responsible for presenting devices logic
final class DevicesPresenter {
    
    private(set) weak var output: DevicesPresenterOutput?
    
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _DevicesPresenter_ with an output object
    ///
    /// - parameter output: The output that conforms to protocol _DevicesPresenterOutput_
    ///
    /// - returns: The instance of _DevicesPresenter_
    init(output: DevicesPresenterOutput) {
        self.output = output
    }
}


// MARK: - DevicesPresenterInput

extension DevicesPresenter: DevicesPresenterInput {
    
    /// Prepares the device models for presentation and tells the output to display devices
    ///
    /// - parameter deviceDatas: The list of device datas
    func presentDevices(deviceDatas: [DeviceData]) {
        let currentTime = Date().timeIntervalSince1970
        let viewModels = deviceDatas.compactMap { device -> DeviceDataViewModel in
            let canSendActivation : Bool = device.lastSentActivation != nil ? device.lastSentActivation! < currentTime : true
            return DeviceDataViewModel(device: Device(name: device.name, type: DeviceType(string: device.type)), status: device.status, thisDevice: device.thisDevice, taskCountString: device.taskCount == 1 ? "\(device.taskCount) Task" : "\(device.taskCount) Tasks", uuid: device.uuid, fingerprint: device.fingerprint, isActivationButtonActive: canSendActivation, os: device.os)
        }
        output?.displayDevices(viewModels: viewModels)
    }
    
    /// Prepares the error model for presentation and tells the output to display error
    ///
    /// - parameter error: The error
    func presentError(error: Error) {
        let errorViewModel = ErrorViewModel(errorText : [Localization.shared.server_error])
        output?.displayError(viewModel: errorViewModel)
    }
    
    /// Displays successful deleted device without preparation
    func presentSuccessfulDeletedDevice() {
        output?.displaySuccessfulDeletedDevice()
    }
    
    /// Prepares the error model for presentation and tells the output to display error
    ///
    /// - parameter deviceData: Device data model
    func activateDevice(deviceData: DeviceData) {
        output?.displayDeviceActivation(with: deviceData)
    }
    
    /// Displays logout due to a bad token without preparation
    func presentLogoutDueToBadToken() {
        output?.displayLogoutDueToBadToken()
    }
}
