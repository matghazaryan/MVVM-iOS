//
//  Card+CoreDataClass.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import CoreData

@objc(Card)
class Card: NSManagedObject {
    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case embossingName = "embossing_name"
        case isDefault = "is_default"
        case cardColor1 = "card_color1"
        case cardType = "card_type"
        case isBlocked = "is_blocked"
        case cardColor2 = "card_color2"
        case expDateYear = "exp_date_year"
        case expDateMonth = "exp_date_month"
        case balanceLabel = "balance_label"
        case displayName = "display_name"
    }
}
