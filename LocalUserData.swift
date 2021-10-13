//
//  LocalUserData.swift
//  Xpert
//
//  Created by Darius on 17/04/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation

struct AppStoreData {
    static let secret : String = "d8e35d24151b446eaee96f40a4001a11"
    static let arrayOfProductIds : Set<String>! = ["dynarisk.Standard", "dynarisk.Advantage", "dynarisk.Ultimate"]
}


final class UserData: NSObject {
    
    static let shared = UserData()
    
    var currentPlan : PlanData
    
    var firstName : String = ""
    var lastName : String = ""
    
    var username : String = ""
    var password : String = ""
    
    var fingerprint : String = ""
    var scan_by : String = ""
    var device_type : String = ""
    
    var phone_number : String = ""
    var country_code : String = ""
    
    var user_uuid : String = ""
    
    var email : String = ""
    var recoveryEmail : String = ""
    
    var currentDeviceUuid : String = ""
    
    var localUserData = LocalUserData()
    
    override init() {
        currentPlan = PlanData(uuid: "", name: "", slug: "", type: "", status: false)
        super.init()
        localUserData.refreshToken = nil
        localUserData.registrationHash = nil
        localUserData.token = nil
    }
}



final class LocalUserData {
    
    var language: String? {
        get { return UserDefaults.standard.string(forKey: "languageKey") } set { UserDefaults.standard.set(newValue, forKey: "languageKey") }
    }
    
    var languageFile: String? {
        get { return UserDefaults.standard.string(forKey: "languageFileKey") } set { UserDefaults.standard.set(newValue, forKey: "languageFileKey") }
    }
    
    var termsLanguageCode: String? {
        get { return UserDefaults.standard.string(forKey: "termsLanguageCodeKey") } set { UserDefaults.standard.set(newValue, forKey: "termsLanguageCodeKey") }
    }
    
    var token: String? {
        get { return UserDefaults.standard.string(forKey: "tokenKey") } set { UserDefaults.standard.set(newValue, forKey: "tokenKey") }
    }
    
    var refreshToken: String? {
        get { return UserDefaults.standard.string(forKey: "refreshTokenKey") } set { UserDefaults.standard.set(newValue, forKey: "refreshTokenKey") }
    }
    
    var registrationHash: String? {
        get { return UserDefaults.standard.string(forKey: "registrationHashKey") } set { UserDefaults.standard.set(newValue, forKey: "registrationHashKey") }
    }
    
    var isAssessmentDone: Bool? {
        get { return UserDefaults.standard.bool(forKey: "isAssessmentDoneKey") } set { UserDefaults.standard.set(newValue, forKey: "isAssessmentDoneKey") }
    }
    
    var isUserTourDone: Bool? {
        get { return UserDefaults.standard.bool(forKey: "isUserTourDoneKey") } set { UserDefaults.standard.set(newValue, forKey: "isUserTourDoneKey") }
    }
    
    var lastUsedAccountUuid: String? {
        get { return UserDefaults.standard.string(forKey: "lastUsedAccountEmailKey")} set { UserDefaults.standard.set(newValue, forKey: "lastUsedAccountEmailKey") }
    }
    
    var lastScannedVulnerability: Int? {
        get { return UserDefaults.standard.integer(forKey: "lastScannedVulnerabilityKey") } set { UserDefaults.standard.set(newValue, forKey: "lastScannedVulnerabilityKey") }
    }
    
    var lastScannedEmails: Int? {
        get { return UserDefaults.standard.integer(forKey: "lastScannedEmailsKey") } set { UserDefaults.standard.set(newValue, forKey: "lastScannedEmailsKey") }
    }
    
    var lastScannedRouter: Int? {
        get { return UserDefaults.standard.integer(forKey: "lastScannedRouterKey") } set { UserDefaults.standard.set(newValue, forKey: "lastScannedRouterKey") }
    }
    
    var appAlreadyLaunched: Bool? {
        get { return UserDefaults.standard.bool(forKey: "appAlreadyLaunchedKey") } set { UserDefaults.standard.set(newValue, forKey: "appAlreadyLaunchedKey") }
    }

    init() {
        if isAssessmentDone == nil { isAssessmentDone = false }
    }
}
