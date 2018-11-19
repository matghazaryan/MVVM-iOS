//
//  APIHelperProtocol.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import Moya

protocol APIHelperProtocol {
    associatedtype MoyaTarget: TargetType
    
    var apiProvider: MoyaProvider<MoyaTarget> { get }
    
    func getConfigs() -> Observable<Configs?>
    func login(email: String, password: String) -> Observable<User?>
    func logOut() -> Observable<Bool>
    func getTransactions(page: Int) -> Observable<(transactions: [Transaction], hasNextPage: Bool)>
    func getCards() -> Observable<[Card]>
}
