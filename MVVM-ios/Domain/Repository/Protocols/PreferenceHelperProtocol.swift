//
//  UserDefaultsHelperProtocol.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

protocol PreferenceHelperProtocol {
    func getToken() -> String?
    func updateToken(_ token: String?)
    func setRememberMe(_ value: Bool)
    func getRememberMe() -> Bool
    func saveConfigJson(_ json: Data?)
    func getConfigJson() -> Data?
    func setAvatarURL(_ url: URL?)
    func getAvatarURL() -> URL?
}
