//
//  SharedViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/17/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SharedViewModel<T>: BaseSharedViewModel {
    typealias SharedData = T
    
    private var sharedDataSparseArray = [AnyHashable: PublishRelay<T?>]()
    private var bagOfSentSharedDataSparseArray = [AnyHashable: T?]()
    
    private func getBaseSharedDataFor(sendCode: AnyHashable) -> PublishRelay<T?> {
        guard let data = sharedDataSparseArray[sendCode] else {
            let item = PublishRelay<T?>()
            sharedDataSparseArray[sendCode] = item
            return item
        }
        return data
    }
    
    private func sendBaseSharedDataFor(sendCode: AnyHashable, data: T?) {
        var mutableLiveData = sharedDataSparseArray[sendCode]
        if mutableLiveData == nil {
            sharedDataSparseArray[sendCode] = PublishRelay<T?>()
        }
        
        mutableLiveData = sharedDataSparseArray[sendCode]
        if mutableLiveData != nil {
            mutableLiveData!.accept(data)
        }
    }
    
    
    func sendSharedDataWith(sendCode: AnyHashable, data: T?) {
        bagOfSentSharedDataSparseArray.removeValue(forKey: sendCode)
        sendBaseSharedDataFor(sendCode: sendCode, data: data);
    }
    
    func getSharedDataFor(sendCode: AnyHashable, listener: SharedDataListener) {
        getBaseSharedDataFor(sendCode: sendCode).bind {[weak self] data in
            guard let weakSelf = self else { return }
            
            let sharedData = weakSelf.bagOfSentSharedDataSparseArray[sendCode]
            
            if sharedData == nil || data == nil {
                weakSelf.bagOfSentSharedDataSparseArray[sendCode] = data
                listener?(data)
            }
            
        }
    }
    
    func getSharedDataAlwaysFor(sendCode: AnyHashable, listener: SharedDataListener) {
        getBaseSharedDataFor(sendCode: sendCode).bind {[weak self] data in
            guard let weakSelf = self else { return }
            weakSelf.bagOfSentSharedDataSparseArray[sendCode] = data
            listener?(data)
        }
    }
}
