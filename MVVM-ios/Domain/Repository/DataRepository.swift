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

class DataRepository: DataRepositoryProtocol {
    
    var apiProvider: MoyaProvider<BaseTargetType> = MoyaProvider()
    private static var sInstance = DataRepository()
    private var userDefaults = UserDefaults(suiteName: "am.mvvm-ios.example.user.defaults")
    
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
            .map({response -> User? in
//                let jsonDict = try JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: Any]
                return try JSONDecoder().decode(User?.self, from: response.data, nestedKeys: "data")
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
    
}
