//
//  NewDevicePresenter.swift
//  Xpert
//
//  Created by Darius on 03/12/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - NewDevicesPresenterInput

/// _NewDevicePresenterInput_ is a protocol for presenter input behaviours
protocol NewDevicePresenterInput: NewDeviceInteractorOutput {
    
}


// MARK: - NewDevicePresenterOutput

/// _NewDevicePresenterOutput_ is a protocol for presenter output behaviours
protocol NewDevicePresenterOutput: AnyObject {
    
    /// Tells the output to dismiss VC after new device request
    ///
    func newDeviceAddedSuccessfully(with data: DeviceDataViewModel)
    
    /// Tells the output to dislpay an error
    ///
    /// - parameter viewModel: The error view model
    func displayError(viewModel: ErrorViewModel)
    
    /// Tells the output to dislpay no data set popup
    func displayNoDataSetPopup()
    
    /// Tells the output to dislpay an error due to plan
    func displayUpgradePlanErrorPopup()
    
    /// Tells the output to dislpay bad token error and logout
    func displayLogoutDueToBadToken()
    
    /// Tells the output to dislpay an error due to not valid device
    func displayNewDeviceAppNotice()
}


// MARK: - NewDevicePresenter

/// _NewDevicePresenter_ is a class responsible for presenting devices logic
final class NewDevicePresenter {
    
    private(set) weak var output: NewDevicePresenterOutput?
    
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _NewDevicePresenter_ with an output object
    ///
    /// - parameter output: The output that conforms to protocol _NewDevicePresenterOutput_
    ///
    /// - returns: The instance of _NewDevicePresenter_
    init(output: NewDevicePresenterOutput) {
        self.output = output
    }
}


// MARK: - NewDevicePresenterInput

extension NewDevicePresenter: NewDevicePresenterInput {
    
    /// Prepare to dismiss VC after successfull new device request
    func newDeviceSavedSuccessfully(with deviceData : DeviceData) {
        let data = DeviceDataViewModel.init(device: Device(name: deviceData.name, type: DeviceType(string: deviceData.type)), status: deviceData.status, thisDevice: deviceData.thisDevice, taskCountString: "\(deviceData.taskCount)", uuid: deviceData.uuid, fingerprint: deviceData.fingerprint, isActivationButtonActive: true, os: deviceData.os)
        output?.newDeviceAddedSuccessfully(with: data)
    }
    
    /// Tells the output to display an error duie to plan
    func presentUpgradePlanErrorPopup() {
        output?.displayUpgradePlanErrorPopup()
    }
    
    /// Prepares the error model for presentation and tells the output to display error
    ///
    /// - parameter error: The error
    func presentError(error: Error) {
        let errorViewModel = ErrorViewModel(errorText : [Localization.shared.server_error])
        output?.displayError(viewModel: errorViewModel)
    }
    
    /// Tells the output to display no data selected error
    func dataNotSelected() {
        output?.displayNoDataSetPopup()
    }
    
    /// Tells the output to display an error due to bad token
    func presentLogoutDueToBadToken() {
        output?.displayLogoutDueToBadToken()
    }
    
    /// Tells the output to display not valid device notice
    func presentNewDeviceAppNotice() {
        output?.displayNewDeviceAppNotice()
    }
}
