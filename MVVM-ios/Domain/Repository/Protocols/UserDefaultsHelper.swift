//
//  UserDefaultsHelper.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

protocol UserDefaultsHelper {
    func prefGetToken() -> String?
    func prefUpdateToken(_ token: String?)
    func prefSetRememberMe(_ value: Bool)
    func prefGetRememberMe() -> Bool
    func prefSaveConfigJson(_ json: Data?)
    func prefGetConfigJson() -> Data?
    func prefSetAvatarURL(_ url: URL?)
    func prefGetAvatarURL() -> URL?
}
