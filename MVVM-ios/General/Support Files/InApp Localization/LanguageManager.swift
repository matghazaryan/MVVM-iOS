//
//  LanguageManager.swift
//  Wether
//
//  Created by Hovhannes Stepanyan on 10/3/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import Foundation

class LanguageManager {
    private static let sInstance = LanguageManager()
    private static let localization = "am.hovhannes.personal.language.manager"
    private let userDefaults = UserDefaults(suiteName: "am.hovhannes.personal.language.manager.userdefaults")
    
    private init() {
        
    }
    
    static func localizedstring(_ key: String, comment: String = "") -> String {
        return NSLocalizedString(key, comment: comment)
    }
}
