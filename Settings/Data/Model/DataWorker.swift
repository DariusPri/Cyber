//
//  DataWorker.swift
//  Xpert
//
//  Created by Darius on 02/05/2019.
//  Copyright © 2019. All rights reserved.
//

import Foundation



// MARK: - DataWorker

/// _DataWorker_ is a worker object responsible to fetch artists from a store
class DataWorker {
    
    fileprivate var store: DataStoreProtocol
    
    
    // MARK: - Initializers
    
    /// Initializes an _DataWorker_ with a store
    ///
    /// - parameter store: A store where to fetch artists from (API, memory, etc)
    ///
    /// - returns: The instance of _DataWorker_
    init(store: DataStoreProtocol = DataAPIStore()) {
        self.store = store
    }
    
    
    // MARK: - Business Logic
    
    
    /// Fetches data from a store
    ///
    /// - parameter completion: The completion block
    func fetchEmailData(completion: @escaping ([EmailData], ErrorViewModel?, Bool) -> ()){
        store.fetchEmailData(completion: completion)
    }
    func fetchCreditData(completion: @escaping ([CreditCardData], ErrorViewModel?, Bool) -> ()){
        store.fetchCreditData(completion: completion)
    }
    func fetchPhoneData(completion: @escaping ([PhoneData], ErrorViewModel?, Bool) -> ()){
        store.fetchPhoneData(completion: completion)
    }
    
    
    /// Sends activation email request  from a store
    ///
    /// - parameter completion: The completion block
    func sendActivationForEmail(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.sendActivationForEmail(with: uuid, completion: completion)
    }
    func sendActivationForPhone(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.sendActivationForPhone(with: uuid, completion: completion)
    }
    func sendActivationForCredit(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.sendActivationForCredit(with: uuid, completion: completion)
    }
    
    
    /// Deletes data from a store
    ///
    /// - parameter completion: The completion block
    func deleteEmail(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.deleteEmail(with: uuid, completion: completion)
    }
    
    func deletePhone(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.deletePhone(with: uuid, completion: completion)
    }
    
    func deleteCard(with uuid : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()){
        store.deleteCard(with: uuid, completion: completion)
    }
    
    /// Adds new data to a store
    ///
    /// - parameter completion: The completion block
    func addNewEmail(with string : String, andIsFamily isFamily : Bool, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        store.addNewEmail(withEmailString: string, andIsFamily: isFamily, completion: completion)
    }
    
    func addNewPhone(with string : String, andCountryCode code: String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        store.addNewPhone(withPhoneStringh: string, andCountryCode: code, completion: completion)
    }
    
    func addNewCard(with string : String, completion: @escaping (Bool, ErrorViewModel?, Bool) -> ()) {
        store.addNewCreditCard(withCreditCardString: string, completion: completion)
    }
    
}

