//
//  Transaction.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxDataSources

struct TransactionData: Decodable {
    var transactions: [TransactionGroup]
    var hasNextPage: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case transactions = "transactions"
        case hasNextPage = "next_page"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transactions = try container.decode([TransactionGroup].self, forKey: .transactions)
        hasNextPage = (try container.decodeIfPresent(Int.self, forKey: .hasNextPage) != nil)
    }
}

struct TransactionGroup: Decodable {
    var transactionList: [Transaction]
    
    enum CodingKeys: String, CodingKey {
        case transactionList = "transaction_details"
    }
}

struct Transaction: Codable {
    var label: String
    var value: String
}

struct TransactionSectionModel: SectionModelType {
    var items: [TransactionGroup]
    
    init(original: TransactionSectionModel, items: [TransactionGroup]) {
        self = original
        self.items = items
    }
    
    init(items: [TransactionGroup]) {
        self.items = items
    }
}

