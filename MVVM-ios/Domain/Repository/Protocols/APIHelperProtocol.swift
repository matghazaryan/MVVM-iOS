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
    
    func apiGetConfigs() -> Observable<Configs?>
    func apiLogin(email: String, password: String) -> Observable<User?>
    func apiLogOut() -> Observable<Bool>
    func apiGetTransactions(page: Int) -> Observable<(transactions: [Transaction], hasNextPage: Bool)>
    func apiGetCards() -> Observable<[Card]>
    func apiUploadImage(_ data: Data) -> Observable<ProgressResponse>
}
