//
//  ApplicationConfigs.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/17/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import Foundation

class ApplicationConfigs: BaseApplicationConfigs {
    var errorMessage: String? {
        return "error_message".localized
    }
    
    var noInternetMessage: String? {
        return "error_no_internet".localized
    }
    
    private static var sInstance: ApplicationConfigs?
    
    private init() {
    }
    
    public static func getInstance() -> ApplicationConfigs {
        guard let instance = sInstance else {
            sInstance = ApplicationConfigs()
            return sInstance!
        }
        return instance
    }
    
}
