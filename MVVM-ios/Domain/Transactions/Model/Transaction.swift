//
//  Transaction.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    var transactionDetails: [TransactionDetail]
    
    enum CodingKeys: String, CodingKey {
        case transactionDetails = "transaction_details"
    }
}

struct TransactionDetail: Codable {
    var label: String
    var value: String
}
