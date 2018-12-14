//
//  Preference.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum UserDefaultsKeys: String {
    case token
    case rememberMe
    case configs
    case avatar
}

class Preference: PreferenceHelperProtocol {
    private var userDefaults = UserDefaults(suiteName: "am.mvvm-ios.example.user.defaults")!
    private static var sInstance = Preference()
    
    static func getInstance() -> Preference {
        return sInstance
    }
    
    // MARK: - PreferenceHelperProtocol
    
    func getToken() -> String? {
        return userDefaults.string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func updateToken(_ token: String?) {
        userDefaults.setValue(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func setRememberMe(_ value: Bool) {
        userDefaults.set(value, forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func getRememberMe() -> Bool {
        return userDefaults.bool(forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func saveConfigJson(_ json: Data?) {
        userDefaults.set(json, forKey: UserDefaultsKeys.configs.rawValue)
    }
    
    func getConfigJson() -> Data? {
        return userDefaults.data(forKey: UserDefaultsKeys.configs.rawValue)
    }
    
    func setAvatarURL(_ url: URL?) {
        userDefaults.set(url, forKey: UserDefaultsKeys.avatar.rawValue)
    }
    
    func getAvatarURL() -> URL? {
        return userDefaults.url(forKey: UserDefaultsKeys.avatar.rawValue)
    }
}
