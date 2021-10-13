//
//  DataInteractor.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - DevicesInteractorInput

/// _DevicesInteractorInput_ is a protocol for interactor input behaviours
protocol DataInteractorInput: DataViewControllerOutput {
    
}


// MARK: - DevicesInteractorOutput

/// _DevicesInteractorOutput_ is a protocol for interactor output behaviours
protocol DataInteractorOutput {
    
 
    
    /// Tells the output to present an error
    ///
    /// - parameter error: The error to present
    func presentError(error: ErrorViewModel)
    
    /// Tells the output to present all Data
    ///
    /// - parameter emailDataArray: The email datas to present
    /// - parameter phoneDataArray: The phone datas to present
    /// - parameter creditCardArray: The credit card datas to present.
    func presentInitialData(with emailDataArray : [EmailData], phoneDataArray : [PhoneData], creditCardArray : [CreditCardData])
    
    
    /// Tells the output to present a successfuly added Data
    ///
    /// - parameter indexPath: successfuly added Data at indexPath  to present
    func presentNewEmailAddedSuccessfuly(at indexPath : IndexPath)
    func presentNewPhoneAddedSuccessfuly(at indexPath : IndexPath)
    func presentNewCardAddedSuccessfuly(at indexPath : IndexPath)
    
    /// Tells the output to present a successfuly deleted Data
    ///
    /// - parameter indexPath: successfuly deleted Data at indexPath to present
    func presentEmailDeletedSuccessfuly(at indexPath : IndexPath)
    func presentPhoneDeletedSuccessfuly(at indexPath : IndexPath)
    func presentCardDeletedSuccessfuly(at indexPath : IndexPath)
    
    /// Tells the output to present a successfuly sent Data activation
    ///
    /// - parameter indexPath: successfuly sent Data activation at indexPath to present
    func presentEmailActivationSuccessfuly(at indexPath : IndexPath)
    func presentPhoneActivationSuccessfuly(at indexPath : IndexPath)
    func presentCardActivationSuccessfuly(at indexPath : IndexPath)

    /// Tells the output to present a logout due to bad token
    func presentLogoutDueToBadToken()

}


// MARK: - DataInteractor

/// _DataInteractor_ is an interactor responsible for data business logic
final class DataInteractor: DataInteractorInput {
    
    let output: DataInteractorOutput
    let worker: DataWorker
        
    var creditCardDataArray : [CreditCardData]?
    var phoneDataArray : [PhoneData]?
    var emailDataArray : [EmailData]?
    
    // MARK: - Initializers
    
    /// Initializes an instance of _DataInteractor_ with an output and a worker
    ///
    /// - parameter output: The interactors output
    /// - parameter worker: The data worker used to fetch devices
    ///
    /// - returns: An instance of _ArtistInteractor_
    init(output: DataInteractorOutput, worker: DataWorker = DataWorker()) {
        self.output = output
        self.worker = worker
    }
    
    
    // MARK: - Business logic
    
    func fetchAllData(){
        
        var numberOfRequests = 3
        
        let savedTimesEmails = self.emailDataArray?.filter({ $0.lastSentActivation != nil })
        let savedTimesCards = self.creditCardDataArray?.filter({ $0.lastSentActivation != nil })
        let savedTimesPhones = self.phoneDataArray?.filter({ $0.lastSentActivation != nil })
        
        var emailDatas : [EmailData] = []
        var phoneDatas : [PhoneData] = []
        var cardDatas : [CreditCardData] = []
        var errorDatas : [String] = []
        
        var skipThisDueToBadToken = false
        
        
        func resetLastActivationTimesEmails() {
            for deviceData in (savedTimesEmails ?? []) {
                if let index = self.emailDataArray!.firstIndex(where: { $0.uuid == deviceData.uuid }) {
                    self.emailDataArray?[index].lastSentActivation = deviceData.lastSentActivation
                }
            }
        }
        
        func resetLastActivationTimesCards() {
            for deviceData in (savedTimesCards ?? []) {
                if let index = self.creditCardDataArray!.firstIndex(where: { $0.uuid == deviceData.uuid }) {
                    self.creditCardDataArray?[index].lastSentActivation = deviceData.lastSentActivation
                }
            }
        }
        
        func resetLastActivationTimesPhones() {
            for deviceData in (savedTimesPhones ?? []) {
                if let index = self.phoneDataArray!.firstIndex(where: { $0.uuid == deviceData.uuid }) {
                    self.phoneDataArray?[index].lastSentActivation = deviceData.lastSentActivation
                }
            }
        }
        
        
        func checkForValidToken(_ token : Bool){
            if token == false { skipThisDueToBadToken = true }
        }
        
        func checkForDone() {
            numberOfRequests -= 1
            if numberOfRequests == 0 {
                if skipThisDueToBadToken == true {
                    SharedRequestStore.shared.updateUserToken(completion: { (success) in
                        if success == true {
                            self.fetchAllData()
                        } else {
                            self.output.presentLogoutDueToBadToken()
                        }
                    })
                    return 
                }
                self.output.presentError(error: ErrorViewModel.init(errorText: errorDatas.count == 0 ? nil : errorDatas ))
                self.emailDataArray = emailDatas
                self.phoneDataArray = phoneDatas
                self.creditCardDataArray = cardDatas
                
                resetLastActivationTimesEmails()
                resetLastActivationTimesCards()
                resetLastActivationTimesPhones()
                
                self.output.presentInitialData(with: emailDatas, phoneDataArray: phoneDatas, creditCardArray: cardDatas)
            }
        }
        
        worker.fetchEmailData { (emailDataArray, errorData, isTokenValid) in
            checkForValidToken(isTokenValid)
            
            if let e = errorData, let eArray = e.errorText {
                errorDatas.append(contentsOf: eArray)
            }
            emailDatas = emailDataArray
            checkForDone()
        }
        
        worker.fetchPhoneData { (phoneDataArray, errorData, isTokenValid) in
            checkForValidToken(isTokenValid)

            if let e = errorData, let eArray = e.errorText {
                errorDatas.append(contentsOf: eArray)
            }
            phoneDatas = phoneDataArray
            checkForDone()
        }
        
        worker.fetchCreditData { (creditDataArray, errorData, isTokenValid) in
            checkForValidToken(isTokenValid)

            if let e = errorData, let eArray = e.errorText {
                errorDatas.append(contentsOf: eArray)
            }
            cardDatas = creditDataArray
            checkForDone()
        }
    }
    
    
    func addNewEmail(withEmailString email : String, andIsFamily isFamily : Bool){
        
        let emailString = email
                
        if email.count == 0 { self.output.presentError(error: ErrorViewModel(errorText: [Localization.shared.data_email_can_t_be_empty_please_try_again])); return }
        if email.isValidEmail() == false { self.output.presentError(error: ErrorViewModel(errorText: [Localization.shared.onboarding_bad_email_format])); return }
        
        worker.addNewEmail(with: email.lowercased(), andIsFamily: isFamily) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentNewEmailAddedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.addNewEmail(withEmailString: emailString, andIsFamily: isFamily)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func addNewPhone(withPhoneStringh phone : String, andCountryCode code : String){
        
        let phoneString = phone
        var countryCode = code
        countryCode.removeFirst(1)
                
        if phone.count == 0 { self.output.presentError(error: ErrorViewModel(errorText: [Localization.shared.data_phone_can_t_be_empty_please_try_again])); return }
        
        worker.addNewPhone(with: phone, andCountryCode: countryCode) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentNewPhoneAddedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.addNewPhone(withPhoneStringh: phoneString, andCountryCode: countryCode)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func addNewCreditCard(withCreditCardString card : String){
        
        let cardString = card
                
        var formattedCardNumber = card
        formattedCardNumber.removeAll(where: { $0 == " " })
        if formattedCardNumber.count == 0 { self.output.presentError(error: ErrorViewModel(errorText: [Localization.shared.data_credit_card_can_t_be_empty_please_try_again])); return }
        if formattedCardNumber.count < 12 || formattedCardNumber.count > 16 { self.output.presentError(error: ErrorViewModel(errorText: [Localization.shared.card_must_contains])); return }
        
        worker.addNewCard(with: formattedCardNumber) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentNewCardAddedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.addNewCreditCard(withCreditCardString: cardString)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func deleteEmail(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let email = emailDataArray?[indexPath.item].uuid else { return }
        worker.deleteEmail(with: email) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentEmailDeletedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.deleteEmail(at: ip)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func deletePhone(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let phone = phoneDataArray?[indexPath.item].uuid else { return }
        worker.deletePhone(with: phone) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentPhoneDeletedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.deletePhone(at: ip)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func deleteCreditCard(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let card = creditCardDataArray?[indexPath.item].uuid else { return }
        worker.deleteCard(with: card) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentCardDeletedSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.deleteCreditCard(at: ip)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    func resendActivationLinkForEmail(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let uuid = emailDataArray?[indexPath.item].uuid else { return }
        worker.sendActivationForEmail(with: uuid) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentEmailActivationSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                      if success == true {
                        self.resendActivationLinkForEmail(at: ip)
                      } else {
                          self.output.presentLogoutDueToBadToken()
                      }
                })
            }
        }
    }
    func resendActivationLinkForPhone(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let uuid = phoneDataArray?[indexPath.item].uuid else { return }
        worker.sendActivationForPhone(with: uuid) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentPhoneActivationSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.resendActivationLinkForPhone(at: ip)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    func resendActivationLinkForCreditCard(at indexPath : IndexPath){
        
        let ip = indexPath
        
        guard let uuid = creditCardDataArray?[indexPath.item].uuid else { return }
        worker.sendActivationForCredit(with: uuid) { (success, errorData, isTokenValid) in
            if success == true {
                self.output.presentCardActivationSuccessfuly(at: IndexPath(item: 0, section: 0))
            } else if let error = errorData {
                self.output.presentError(error: error)
            } else if isTokenValid == false {
                SharedRequestStore.shared.updateUserToken(completion: { (success) in
                    if success == true {
                        self.resendActivationLinkForCreditCard(at: ip)
                    } else {
                        self.output.presentLogoutDueToBadToken()
                    }
                })
            }
        }
    }
    
    
    
    func setActivationEmailTimerForEmail(at indexPath: IndexPath) {
        self.emailDataArray?[indexPath.item].lastSentActivation = Date().timeIntervalSince1970.advanced(by: 5 * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + (5 * 60) + 5) {
            self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
        }
        self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
    }
    
    func setActivationEmailTimerForPhone(at indexPath: IndexPath) {
        self.phoneDataArray?[indexPath.item].lastSentActivation = Date().timeIntervalSince1970.advanced(by: 5 * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + (5 * 60) + 5) {
            self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
        }
        self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
    }
    
    func setActivationEmailTimerForCard(at indexPath: IndexPath) {
        self.creditCardDataArray?[indexPath.item].lastSentActivation = Date().timeIntervalSince1970.advanced(by: 5 * 60)
        DispatchQueue.main.asyncAfter(deadline: .now() + (5 * 60) + 5) {
            self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
        }
        self.output.presentInitialData(with: self.emailDataArray ?? [], phoneDataArray: self.phoneDataArray ?? [], creditCardArray: self.creditCardDataArray ?? [])
    }
    
}
