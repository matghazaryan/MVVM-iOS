//
//  Card+CoreDataProperties.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import CoreData

extension Card {
    open class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest(entityName: "Cards")
    }
    
    @NSManaged var cardNumber: String
    @NSManaged var embossingName: String
    @NSManaged var isDefault: Bool
    @NSManaged var cardColor1: String
    @NSManaged var cardType: String
    @NSManaged var isBlocked: Bool
    @NSManaged var cardColor2: String
    @NSManaged var expDateYear: String
    @NSManaged var expDateMonth: String
    @NSManaged var balanceLabel: String
    @NSManaged var displayName: String
}
