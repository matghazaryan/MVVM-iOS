//
//  Api.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class Api: APIHelperProtocol {
    private static var sInstance = Api()
    public var apiProvider: MoyaProvider<BaseTargetType> = MoyaProvider()
    
    static func getInstance() -> Api {
        return sInstance
    }
    
    // MARK: - APIHelperProtocol
    
    func getConfigs() -> Observable<Configs?> {
        return apiProvider.rx
            .request(.configs)
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: {response in
                DataRepository.preference().saveConfigJson(response.data)
                }, onError: {
                    print($0.localizedDescription)
            })
            .asDriver(onErrorRecover: {error -> SharedSequence<DriverSharingStrategy, Response> in
                guard let data = DataRepository.preference().getConfigJson() else {
                    return SharedSequence.just(Response.init(statusCode: 200, data: Data()))
                }
                return SharedSequence.just(Response.init(statusCode: 200, data: data))
            })
            .map({response -> Configs? in
                return try? JSONDecoder().decode(Configs.self, from: response.data, nestedKeys: "data")
            })
            .asObservable()
    }
    
    func login(email: String, password: String) -> Observable<User?> {
        return apiProvider.rx
            .request(.login(email: email, password: password))
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .map({response -> User? in
                let user = try JSONDecoder().decode(User?.self, from: response.data, nestedKeys: "data")
                DataRepository.preference().updateToken(user?.token)
                return user
            })
            .asObservable()
    }
    
    func logOut() -> Observable<Void> {
        return apiProvider.rx
            .request(.logout)
            .observeOn(MainScheduler.asyncInstance)
            .map({ response -> Void in
                print(response)
                return
            })
            .asObservable()
    }
    
    func getTransactions(page: Int) -> Observable<TransactionData> {
        return apiProvider.rx
            .request(BaseTargetType.transactions(page: page))
            .observeOn(MainScheduler.asyncInstance)
            .map({ response -> TransactionData in
                let transactions = try JSONDecoder().decode(TransactionData.self, from: response.data, nestedKeys: "data")
                return transactions
            })
            .asObservable()
    }
    
    func getCards() -> Observable<[Card]> {
        return apiProvider.rx
            .request(.cards)
            .observeOn(MainScheduler.asyncInstance)
            .map([Card].self, atKeyPath: "data.cards_list", using: JSONDecoder(), failsOnEmptyData: false)
            .do(onSuccess: { _ in
                CoreDataManager.sInstance.saveContext()
            })
            .asObservable()
    }
    
    func uploadImage(_ data: Data) -> Observable<ProgressResponse> {
        return apiProvider.rx
            .requestWithProgress(.uploadImage(data))
            .observeOn(MainScheduler.asyncInstance)
            .asObservable()
    }
}
