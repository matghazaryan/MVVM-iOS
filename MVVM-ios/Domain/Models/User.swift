//
//  User.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/9/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

struct User: Codable {
    var email: String
    var token: String
    var twoStepEnabled: Bool
}
