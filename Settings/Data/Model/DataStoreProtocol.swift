//
//  DataStoreProtocol.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation


// MARK: - DataStoreError

/// _DataStoreError_ is an enumeration for artist store errors
///
/// - generic:         Generic error
/// - invalidURL:      Invalid URL error
/// - invalidResponse: Invalid response
enum DataStoreError: Error {
    case generic
    case invalidURL
    case invalidResponse
}


// MARK: - DataStoreProtocol

/// _DataStoreProtocol_ is a protocol  for artist store behaviors
protocol DataStoreProtocol {
    
    /// Fetches data from a store
    ///
    /// - parameter completion: The completion block
    func fetchEmailData(completion: @escaping ([EmailData], ErrorViewModel?, Bool) -> ())
    func fetchCreditData(completion: @escaping ([CreditCardData], ErrorViewModel?, Bool) -> ())
    func fetchPhoneData(completion: @escaping ([PhoneData], ErrorViewModel?, Bool) -> ())

    
    /// sends activation data to a store
    ///
    /// - parameter completion: The completion block
    func sendActivationForEmail(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    func sendActivationForPhone(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    func sendActivationForCredit(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    
    /// deletes  data from a store
    ///
    /// - parameter completion: The completion block
    /// - parameter uuid: Unique data id
    func deleteEmail(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    func deletePhone(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    func deleteCard(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())

    /// adds new data to a store
    ///
    /// - parameter completion: The completion block
    /// - parameter data : Data string
    
    func addNewEmail(withEmailString email: String, andIsFamily isFamily: Bool,  completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())    
    func addNewPhone(withPhoneStringh phone: String, andCountryCode code : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
    func addNewCreditCard(withCreditCardString card : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ())
}
