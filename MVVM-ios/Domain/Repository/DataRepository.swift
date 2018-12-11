//
//  DataRepository.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import CoreData

enum UserDefaultsKeys: String {
    case token
    case rememberMe
    case configs
    case avatar
}

enum KeychainKeys: String {
    case email
    case password
}

class DataRepository: DataRepositoryProtocol {
    
    var apiProvider: MoyaProvider<BaseTargetType> = MoyaProvider()
    private static var sInstance = DataRepository()
    private var userDefaults = UserDefaults(suiteName: "am.mvvm-ios.example.user.defaults")!
    
    static func getInstance() -> DataRepository {
        return sInstance
    }
    
    // MARK: - APIHelperProtocol
    
    func apiGetConfigs() -> Observable<Configs?> {
        return apiProvider.rx
            .request(.configs)
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: {[weak self] response in
                self?.prefSaveConfigJson(response.data)
                }, onError: {
                    print($0.localizedDescription)
            })
            .asDriver(onErrorRecover: {[weak self] error -> SharedSequence<DriverSharingStrategy, Response> in
                guard let data = self?.prefGetConfigJson() else {
                        return SharedSequence.just(Response.init(statusCode: 200, data: Data()))
                    }
                return SharedSequence.just(Response.init(statusCode: 200, data: data))
            })
            .map({response -> Configs? in
                return try? JSONDecoder().decode(Configs.self, from: response.data, nestedKeys: "data")
            })
            .asObservable()
    }
    
    func apiLogin(email: String, password: String) -> Observable<User?> {
        return apiProvider.rx
            .request(.login(email: email, password: password))
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .map({[weak self] response -> User? in
                let user = try JSONDecoder().decode(User?.self, from: response.data, nestedKeys: "data")
                self?.prefUpdateToken(user?.token)
                return user
            })
            .asObservable()
    }
    
    func apiLogOut() -> Observable<Void> {
        return apiProvider.rx
            .request(.logout)
            .observeOn(MainScheduler.asyncInstance)
            .map({ response -> Void in
                print(response)
                return
            })
            .asObservable()
    }
    
    func apiGetTransactions(page: Int) -> Observable<(transactions: [Transaction], hasNextPage: Bool)> {
        return apiProvider.rx
            .request(BaseTargetType.transactions(page: page))
            .observeOn(MainScheduler.asyncInstance)
            .map({ response -> (transactions: [Transaction], hasNextPahde: Bool) in
                let transactions = try JSONDecoder().decode([Transaction].self, from: response.data, nestedKeys: "data", "transactions")
                let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as! [String: Any]
                let hasNextPage = ((json["data"] as! [String: Any])["next_page"] != nil)
                return (transactions, hasNextPage)
            })
            .asObservable()
    }
    
    func apiGetCards() -> Observable<[Card]> {
        return apiProvider.rx
            .request(.cards)
            .observeOn(MainScheduler.asyncInstance)
            .map([Card].self, atKeyPath: "data.cards_list", using: JSONDecoder(), failsOnEmptyData: false)
            .do(onSuccess: { _ in
                CoreDataManager.sInstance.saveContext()
            })
            .asObservable()
    }
    
    func apiUploadImage(_ data: Data) -> Observable<ProgressResponse> {
        return apiProvider.rx
            .requestWithProgress(.uploadImage(data))
            .observeOn(MainScheduler.asyncInstance)
//            .do(onNext: { response in
//                if response.completed {
//                    print(response.response)
//                } else {
//                    print("progress = \(response.progress)")
//                }
//            }, onError: {
//                print("errror \($0)")
//            })
//            .asObservable()
    }
    
    // MARK: - DBHelperProtocol
    
    func dbGetConfigsFromCache() -> Observable<Configs?> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Configs")
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Configs", in: )
        return Observable.just(nil)
    }
    
    func dbGetCardsFromCache() -> Observable<[Card]> {
        guard let cards = try? CoreDataManager.fetchAllObjectsForType(Card.self) else {
            return Observable.just([])
        }
        return Observable.just(cards)
    }
    
    // MARK: - UserDefaultsHelper
    
    func prefGetToken() -> String? {
        return userDefaults.string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func prefUpdateToken(_ token: String?) {
        userDefaults.setValue(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func prefSetRememberMe(_ value: Bool) {
        userDefaults.set(value, forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func prefGetRememberMe() -> Bool {
        return userDefaults.bool(forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func prefSaveConfigJson(_ json: Data?) {
        userDefaults.set(json, forKey: UserDefaultsKeys.configs.rawValue)
    }
    
    func prefGetConfigJson() -> Data? {
        return userDefaults.data(forKey: UserDefaultsKeys.configs.rawValue)
    }
    
    func prefSetAvatarURL(_ url: URL?) {
        userDefaults.set(url, forKey: UserDefaultsKeys.avatar.rawValue)
    }
    
    func prefGetAvatarURL() -> URL? {
        return userDefaults.url(forKey: UserDefaultsKeys.avatar.rawValue)
    }
    
    // MARK: - KeychainManager
    
    func saveEmail(_ email: String) {
        let _ = KeychainManager.KMSaveOrUpdate(value: email, forKey: KeychainKeys.email.rawValue)
    }
    
    func getEmail() -> String? {
        return KeychainManager.KMGetValue(forKey: KeychainKeys.email.rawValue)
    }
    
    func savePassword(_ password: String) {
        let _ = KeychainManager.KMSaveOrUpdate(value: password, forKey: KeychainKeys.password.rawValue)
    }
    
    func getPassword() -> String? {
        return KeychainManager.KMGetValue(forKey: KeychainKeys.password.rawValue)
    }
}
