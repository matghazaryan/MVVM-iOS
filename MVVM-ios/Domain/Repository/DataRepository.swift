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
    
    static func getInstance() -> DataRepository {
        return sInstance
    }
    
    func getConfigs() -> Observable<Configs?> {
        return apiProvider.rx
            .request(.configs)
            .subscribeOn(CurrentThreadScheduler.instance)
            .observeOn(MainScheduler.asyncInstance)
            .map(Configs?.self)
            .asObservable()
    }
    
    func getConfigsFromCache() -> Observable<Configs?> {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Configs")
//        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Configs", in: )
        return Observable.just(nil)
    }
    
    
}
