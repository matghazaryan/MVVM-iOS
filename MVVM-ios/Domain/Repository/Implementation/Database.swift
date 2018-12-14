//
//  Database.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class Database: DBHelperProtocol {
    private static var sInstance = Database()
    
    static func getInstance() -> Database {
        return sInstance
    }
    // MARK: - DBHelperProtocol
    
    func getCardsFromCache() -> Observable<[Card]> {
        guard let cards = try? CoreDataManager.fetchAllObjectsForType(Card.self) else {
            return Observable.just([])
        }
        return Observable.just(cards)
    }
    
    func clearCardTable() -> Bool {
        return CoreDataManager.clearDataBase(Card.self)
    }
}
