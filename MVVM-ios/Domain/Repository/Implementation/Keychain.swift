//
//  Keychain.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

class Keychain: KeychainHelperProtocol {
    private static var sInstance = Keychain()
    
    static func getInstance() -> Keychain {
        return sInstance
    }
    
    // MARK: - KeychainManager
    
    func saveEmail(_ email: String) {
        let _ = KeychainManager.KMSaveOrUpdate(value: email, forKey: KeychainKeys.email.rawValue)
    }
    
    func getEmail() -> String? {
        return KeychainManager.KMGetValue(forKey: KeychainKeys.email.rawValue)
    }
    
    func savePassword(_ password: String) {
        let _ = KeychainManager.KMSaveOrUpdate(value: password, forKey: KeychainKeys.password.rawValue)
    }
    
    func getPassword() -> String? {
        return KeychainManager.KMGetValue(forKey: KeychainKeys.password.rawValue)
    }
}
