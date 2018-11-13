//
//  UserDefaultsHelper.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

protocol UserDefaultsHelper {
    func getToken() -> String?
    func updateToken(_ token: String?)
    func setRememberMe(_ value: Bool)
    func getRememberMe() -> Bool
}
