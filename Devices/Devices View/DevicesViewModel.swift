//
//  DevicesViewModel.swift
//  Xpert
//
//  Created by Darius on 29/11/2018.
//  Copyright © 2018. All rights reserved.
//

import Foundation


// MARK: - Device Data Model

enum DeviceStatus {
    case active
    case inactive
    case disabled
    
    init(text : String) {
        if text == "active" { self = .active }
        else if text == "pending" { self = .inactive }
        else if text == "disabled" { self = .disabled }
        else { self = .active }
    }
    
    func getString() -> String {
        if self == .active { return "Active" }
        else if self == .inactive { return "Inactive" }
        else if self == .disabled { return "Disabled" }
        return ""
    }
}

enum DeviceOS : String {
    case ios = "iOS"
    case android = "Android"
    case windows = "Windows"
    case mac = "Mac"
    
    init(text : String) {
        if text.lowercased() == "ios" {
            self = .ios
        } else if text.lowercased() == "android" {
            self = .android
        } else if text.lowercased() == "windows" || text.lowercased() == "pc" {
            self = .windows
        } else if text.lowercased() == "macosx" || text.lowercased() == "apple" {
            self = .mac
        } else {
            self = .ios
        }
     }
}

struct DeviceData {
    var name : String
    var type : String
    var os : DeviceOS
    var status : DeviceStatus
    var thisDevice : Bool
    var taskCount : Int
    var uuid : String
    var fingerprint : String
    var lastSentActivation : TimeInterval?
    
}

// MARK: - DeviceDataViewModel

struct DeviceDataViewModel {
    var device : Device
    var status : DeviceStatus
    var thisDevice : Bool
    var taskCountString : String
    var uuid : String
    var fingerprint : String
    var isActivationButtonActive : Bool
    var os : DeviceOS
}
