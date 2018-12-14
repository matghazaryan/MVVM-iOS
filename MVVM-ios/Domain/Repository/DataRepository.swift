//
//  DataRepository.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import CoreData

enum KeychainKeys: String {
    case email
    case password
}

class DataRepository {
    
    static func api() -> Api {
        return Api.getInstance()
    }
    
    static func preference() -> Preference {
        return Preference.getInstance()
    }
    
    static func database() -> Database {
        return Database.getInstance()
    }
    
    static func keychain() -> Keychain {
        return Keychain.getInstance()
    }
}
