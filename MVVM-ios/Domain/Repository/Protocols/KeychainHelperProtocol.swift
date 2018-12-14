//
//  KeychainHelperProtocol.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

protocol KeychainHelperProtocol {
    
    func saveEmail(_ email: String)
    func getEmail() -> String?
    func savePassword(_ password: String)
    func getPassword() -> String?
}
