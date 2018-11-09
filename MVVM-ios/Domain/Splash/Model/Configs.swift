//
//  Configs.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

class Configs: Decodable {
    var callCenter: String
    var loginTime: Int64
    var amountMinValue: Int64
    var cardMinValue: Int64
    var cardMaxValue: Int64
    var autopaymentCount: Int64
    var reviewCount: Int64
    var payxUrl: String
    var symbolsCount: Int64
    var twoAuthUrl: String
    var termsConditionUrl: String
    var notificationTime: Int64
    var amountFormat: String
    var amountSign: String?
    
    enum CodingKeys: String, CodingKey {
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
    
//    enum CodingKeys: String, CodingKey {
//        case data
//    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self).nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .data)
//        callCenter = try container.decode(String.self, forKey: .callCenter)
//        loginTime = try container.decode(Int64.self, forKey: .loginTime)
//        amountMinValue = try container.decode(Int64.self, forKey: .amountMinValue)
//        cardMinValue = try container.decode(Int64.self, forKey: .cardMinValue)
//        cardMaxValue = try container.decode(Int64.self, forKey: .cardMaxValue)
//        autopaymentCount = try container.decode(Int64.self, forKey: .autopaymentCount)
//        reviewCount = try container.decode(Int64.self, forKey: .reviewCount)
//        payxUrl = try container.decode(String.self, forKey: .payxUrl)
//        symbolsCount = try container.decode(Int64.self, forKey: .symbolsCount)
//        twoAuthUrl = try container.decode(String.self, forKey: .twoAuthUrl)
//        termsConditionUrl = try container.decode(String.self, forKey: .termsConditionUrl)
//        notificationTime = try container.decode(Int64.self, forKey: .notificationTime)
//        amountFormat = try container.decode(String.self, forKey: .amountFormat)
//        amountSign = try container.decodeIfPresent(String.self, forKey: .amountSign)
//    }
}
