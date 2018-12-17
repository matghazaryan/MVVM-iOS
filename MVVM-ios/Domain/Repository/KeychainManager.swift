//
//  KeychainManager.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import Security

let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeychainManager {
    private static let account = Bundle.main.bundleIdentifier!
    
    static func KMSave(value: String, forKey key: String) -> OSStatus {
        if let dataFromString = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(
                objects: [kSecClassGenericPasswordValue, key, account, dataFromString],
                forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            return SecItemAdd(keychainQuery as CFDictionary, nil)
        }
        return errSecBadReq
    }
    
    static func KMUpdate(value: String, forKey key: String) -> OSStatus {
        if let dataFromString: Data = value.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery = NSMutableDictionary(
                objects: [kSecClassGenericPasswordValue, key, account],
                forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue]
            )
            
            return SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
        }
        return errSecBadReq
    }
    
    static func KMSaveOrUpdate(value: String, forKey key: String) -> OSStatus {
        guard let _ = KMGetValue(forKey: key) else {
            return KMSave(value: value, forKey: key)
        }
        return KMUpdate(value: value, forKey: key)
    }
    
    static func KMRemoveValue(forKey key: String) throws -> OSStatus {
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(
            objects: [kSecClassGenericPasswordValue, key, account, kCFBooleanTrue],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue])
        
        let status = SecItemDelete(keychainQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            if #available(iOS 11.3, *) {
                let err = SecCopyErrorMessageString(status, nil)
                var userInfo: [String: Any] = [kCFErrorDomainOSStatus as String: status]
                userInfo[kCFErrorLocalizedFailureReasonKey as String] = err
                throw NSError(domain: "delete password failed",
                              code: Int(status),
                              userInfo: userInfo) as Error
            } else {
                // Fallback on earlier versions
                throw NSError(domain: "delete password failed",
                              code: Int(status),
                              userInfo: [kCFErrorDomainOSStatus as String: status]) as Error
            }
        }
        return status
    }
    
    static func KMGetValue(forKey key: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(
            objects: [kSecClassGenericPasswordValue, key, account, kCFBooleanTrue, kSecMatchLimitOneValue],
            forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
