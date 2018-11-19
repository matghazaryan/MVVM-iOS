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
class Card: NSManagedObject, Decodable {
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
    
    required convenience init(from decoder: Decoder) throws {
        let context = CoreDataManager.sInstance.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Card", in: context) else {
            fatalError()
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cardNumber = try container.decode(String.self, forKey: .cardNumber)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Card.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        fetchRequest.predicate = NSPredicate(format: "%@=%@", "cardNumber", cardNumber)
        fetchRequest.resultType = .countResultType
        guard let result = try context.execute(deleteRequest) as? NSBatchDeleteResult,
            let count = result.result as? Int else {
            fatalError()
        }
        print("\(count) item was deleted, cardNumber = \(cardNumber)")
        self.init(entity: entity, insertInto: context)
        self.cardNumber = cardNumber
        self.embossingName = try container.decode(String.self, forKey: .embossingName)
        self.isDefault = try container.decode(Bool.self, forKey: .isDefault)
        self.cardColor1 = try container.decode(String.self, forKey: .cardColor1)
        self.cardType = try container.decode(String.self, forKey: .cardType)
        self.isBlocked = try container.decode(Bool.self, forKey: .isBlocked)
        self.cardColor2 = try container.decode(String.self, forKey: .cardColor2)
        self.expDateYear = try container.decode(String.self, forKey: .expDateYear)
        self.expDateMonth = try container.decode(String.self, forKey: .expDateMonth)
        self.balanceLabel = try container.decode(String.self, forKey: .balanceLabel)
        self.displayName = try container.decode(String.self, forKey: .displayName)
    }
    
    override class func primaryKey() -> String {
        return "cardNumber"
    }
}
