//
//  DataViewModel.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation

struct EmailData {
    var uuid : String?
    var email : String
    var isActive : Bool
    var isFamily : Bool
    var lastSentActivation : TimeInterval?
}

struct CreditCardData {
    var uuid : String?
    var name : String
    var isActive : Bool
    var lastSentActivation : TimeInterval?
}

struct PhoneData {
    var uuid : String?
    var name : String
    var isActive : Bool
    var lastSentActivation : TimeInterval?
}

struct EmailDataViewModel {
    var infoButtonVisible : Bool
    var email : String
    var isActive : Bool
    var isFamily : Bool
    var isActivationButtonActive : Bool
}

struct CreditCardDataViewModel {
    var infoButtonVisible : Bool
    var creditCardNumber : String
    var isActive : Bool
    var isActivationButtonActive : Bool
}

struct PhoneDataViewModel {
    var infoButtonVisible : Bool
    var phoneNumber : String
    var isActive : Bool
    var isActivationButtonActive : Bool
}

struct DataViewModel {
    var currentIndex : Int = 0
    var emailDatas : [EmailDataViewModel] = []
    var creditCardDatas : [CreditCardDataViewModel] = []
    var phoneDatas : [PhoneDataViewModel] = []
    var errorViewModel : ErrorViewModel?
    
    func getCurrentCardName() -> String {
        let sectionNames = ["PROTECTED EMAILS", "PROTECTED CREDIT CARDS", "PROTECTED PHONES"]
        return sectionNames[currentIndex]
    }
    
    func getCorrectName() -> String {
        let names = [Localization.shared.data_email, Localization.shared.credit_card, Localization.shared.phone_number]
        return names[currentIndex]
    }
}
