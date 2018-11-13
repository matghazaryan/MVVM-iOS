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
    
    func getConfigs() -> Observable<Configs?> {
        return apiProvider.rx
            .request(.configs)
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .map({response -> Configs? in
                return try JSONDecoder().decode(Configs?.self, from: response.data, nestedKeys: "data")
            })
            .asObservable()
    }
    
    func getConfigsFromCache() -> Observable<Configs?> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Configs")
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Configs", in: )
        return Observable.just(nil)
    }
    
    func login(email: String, password: String) -> Observable<User?> {
        return apiProvider.rx
            .request(.login(email: email, password: password))
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .map({[weak self] response -> User? in
//                let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                let user = try JSONDecoder().decode(User?.self, from: response.data, nestedKeys: "data")
                self?.updateToken(user?.token)
                return user
            })
            .asObservable()
    }
    
    func logOut() -> Observable<Bool> {
        return apiProvider.rx
            .request(.logout)
            .observeOn(MainScheduler.asyncInstance)
            .map({ response -> Bool in
                print(response)
                return true
            })
            .asObservable()
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: UserDefaultsKeys.token.rawValue)
    }
    
    func updateToken(_ token: String?) {
        userDefaults.setValue(token, forKey: UserDefaultsKeys.token.rawValue)
    }
    
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
    
    func setRememberMe(_ value: Bool) {
        userDefaults.set(value, forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
    
    func getRememberMe() -> Bool {
        return userDefaults.bool(forKey: UserDefaultsKeys.rememberMe.rawValue)
    }
}
