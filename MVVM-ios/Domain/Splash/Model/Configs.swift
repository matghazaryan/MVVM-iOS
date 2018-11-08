//
//  Configs.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

class Configs: Codable {
    var callCenter: String
    var loginTime: Int
    var amountMinValue: Int
    var cardMinValue: Int
    var cardMaxValue: Int
    var autopaymentCount: Int
    var reviewCount: Int
    var payxUrl: String
    var symbolsCount: Int
    var twoAuthUrl: String
    var termsConditionUrl: String
    var notificationTime: Int
    var amountFormat: String
    var amountSign: String?
    
    enum NestedCodingKeys: String, CodingKey {
        case callCenter = "call_center"
        case loginTime = "login_time"
        case amountMinValue = "amount_min_value"
        case cardMinValue = "card_min_value"
        case cardMaxValue = "card_max_value"
        case autopaymentCount = "autopayment_count"
        case reviewCount = "review_count"
        case payxUrl = "payx_url"
        case symbolsCount = "autologin_symbols_count"
        case twoAuthUrl = "two_auth_url"
        case termsConditionUrl = "terms_condition_url"
        case notificationTime = "notification_time"
        case amountFormat = "amount_format"
        case amountSign = "amd_sign"
    }
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self).nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .data)
        let
    }
}
