//
//  DBHelperProtocol.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift

protocol DBHelperProtocol {
    func getCardsFromCache() -> Observable<[Card]>
    func clearCardTable() -> Bool
}
