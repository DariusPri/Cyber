//
//  DataPresenter.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation



// MARK: - DataPresenterInput

/// _DataPresenterInput_ is a protocol for presenter input behaviours
protocol DataPresenterInput: DataInteractorOutput {
    
}


// MARK: - DataPresenterOutput

/// _DataPresenterOutput_ is a protocol for presenter output behaviours
protocol DataPresenterOutput: AnyObject {
    
    /// Tells the output to dislpay an error
    ///
    /// - parameter viewModel: The error view model
    func displayError(viewModel: ErrorViewModel)
    
    
    /// Tells the output to dislpay all data
    ///
    /// - parameter model: The Data view model
    func displayAllData(withDataModel model : DataViewModel)
    
    
    
    /// Tells the output to dislpay successful data activation
    ///
    /// - parameter indexPath: The position for collectionViewCell
    func displaySuccessfulEmailActivationSent(at indexPath : IndexPath)
    func displaySuccessfulPhoneActivationSent(at indexPath : IndexPath)
    func displaySuccessfulCardActivationSent(at indexPath : IndexPath)
    
    
    /// Tells the output to dislpay successfuly added data
    ///
    /// - parameter indexPath: The position for collectionViewCell
    func displaySuccessfulNewEmail(at indexPath : IndexPath)
    func displaySuccessfulNewPhone(at indexPath : IndexPath)
    func displaySuccessfulNewCard(at indexPath : IndexPath)

    
    /// Tells the output to dislpay successfuly deleted data
    ///
    /// - parameter indexPath: The position for collectionViewCell
    func displaySuccessfulDeletedEmail(at indexPath : IndexPath)
    func displaySuccessfulDeletedPhone(at indexPath : IndexPath)
    func displaySuccessfulDeletedCard(at indexPath : IndexPath)
    
    /// Tells the output to logout due to bad token
    func displayLogoutDueToBadToken()
}


// MARK: - DataPresenter

/// _DataPresenter_ is a class responsible for presenting data logic
final class DataPresenter {
    
    private(set) weak var output: DataPresenterOutput?
    
    
    // MARK: - Initializers
    
    /// Initializes a new instance of _DataPresenter_ with an output object
    ///
    /// - parameter output: The output that conforms to protocol _DataPresenterOutput_
    ///
    /// - returns: The instance of _DataPresenter_
    init(output: DataPresenterOutput) {
        self.output = output
    }
}


// MARK: - DataPresenterInput

extension DataPresenter: DataPresenterInput {

    
    /// Prepares the error model for presentation and tells the output to display error
    ///
    /// - parameter error: The error
    func presentError(error: ErrorViewModel) {
        output?.displayError(viewModel: error)
    }
    
    /// Prepares the data models for presentation and tells the output to display all data
    ///
    /// - parameter emailDataArray: Email data array
    /// - parameter phoneDataArray: Phone data array
    /// - parameter creditCardArray: Credit card data array
    func presentInitialData(with emailDataArray: [EmailData], phoneDataArray: [PhoneData], creditCardArray: [CreditCardData]) {
        
        let currentTime = Date().timeIntervalSince1970
        
        let emailDatas : [EmailDataViewModel] = emailDataArray.map { (emailData) -> EmailDataViewModel in
            let canSendActivation : Bool = emailData.lastSentActivation != nil ? emailData.lastSentActivation! < currentTime : true
            return EmailDataViewModel(infoButtonVisible: emailData.uuid != nil, email: emailData.email, isActive: emailData.isActive, isFamily: emailData.isFamily, isActivationButtonActive: canSendActivation)
        }
        
        let cardDatas : [CreditCardDataViewModel] = creditCardArray.map { (cardData) -> CreditCardDataViewModel in
            let canSendActivation : Bool = cardData.lastSentActivation != nil ? cardData.lastSentActivation! < currentTime : true
            return CreditCardDataViewModel(infoButtonVisible: cardData.uuid != nil, creditCardNumber: cardData.name, isActive: cardData.isActive, isActivationButtonActive: canSendActivation)
        }
        
        let phoneDatas : [PhoneDataViewModel] = phoneDataArray.map { (phoneData) -> PhoneDataViewModel in
            let canSendActivation : Bool = phoneData.lastSentActivation != nil ? phoneData.lastSentActivation! < currentTime : true
            return PhoneDataViewModel(infoButtonVisible: phoneData.uuid != nil, phoneNumber: phoneData.name, isActive: phoneData.isActive, isActivationButtonActive: canSendActivation)
        }
        
        let model = DataViewModel(currentIndex: 0, emailDatas: emailDatas, creditCardDatas: cardDatas, phoneDatas: phoneDatas, errorViewModel: nil)
        output?.displayAllData(withDataModel: model)
    }
    
    
    /// Prepares the data models for presentation and tells the output to display display successfuly added data
    ///
    /// - parameter indexPath: CollectionView index for new data
    func presentNewEmailAddedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulNewEmail(at: IndexPath(item: 0, section: 0))
    }
    
    func presentNewPhoneAddedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulNewPhone(at: IndexPath(item: 0, section: 0))
    }
    
    func presentNewCardAddedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulNewCard(at: IndexPath(item: 0, section: 0))
    }
    
    
    /// Prepares the data models for presentation and tells the output to display deleted data
    ///
    /// - parameter indexPath: CollectionView index for deleted data
    func presentEmailDeletedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulDeletedEmail(at: IndexPath(item: 0, section: 0))
    }
    
    func presentPhoneDeletedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulDeletedPhone(at: IndexPath(item: 0, section: 0))
    }
    
    func presentCardDeletedSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulDeletedCard(at: IndexPath(item: 0, section: 0))
    }
    
    
    /// Prepares the data models for presentation and tells the output to display activation sent dialog
    ///
    /// - parameter indexPath: CollectionView index for activation data
    func presentEmailActivationSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulEmailActivationSent(at: IndexPath(item: 0, section: 0))
    }
    
    func presentPhoneActivationSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulPhoneActivationSent(at: IndexPath(item: 0, section: 0))
    }
    
    func presentCardActivationSuccessfuly(at indexPath : IndexPath){
        output?.displaySuccessfulCardActivationSent(at: IndexPath(item: 0, section: 0))
    }
    
    
    /// Prepares the data models for presentation and tells the output to display a logout due to bad token
    func presentLogoutDueToBadToken() {
        output?.displayLogoutDueToBadToken()
    }
    

}
