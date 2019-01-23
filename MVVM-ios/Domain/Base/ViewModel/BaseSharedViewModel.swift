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

class BaseSharedViewModel<T>: PBaseSharedViewModel {
    typealias SharedData = T
    
    private var sharedDataSparseArray = [AnyHashable: BehaviorRelay<T?>]()
    private var bagOfSentSharedDataSparseArray = [AnyHashable: T?]()
    
    private func getBaseSharedDataFor(sendCode: AnyHashable) -> BehaviorRelay<T?> {
        guard let data = sharedDataSparseArray[sendCode] else {
            let item = BehaviorRelay<T?>(value: nil)
            sharedDataSparseArray[sendCode] = item
            return item
        }
        return data
    }
    
    private func sendBaseSharedDataFor(sendCode: AnyHashable, data: T?) {
        var mutableLiveData = sharedDataSparseArray[sendCode]
        if mutableLiveData == nil {
            sharedDataSparseArray[sendCode] = BehaviorRelay<T?>(value: nil)
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
    
    func getSharedDataFor(sendCode: AnyHashable, listener: SharedDataListener) -> Disposable {
        return getBaseSharedDataFor(sendCode: sendCode).bind {[weak self] data in
            guard let weakSelf = self else { return }
            
            let sharedData = weakSelf.bagOfSentSharedDataSparseArray[sendCode]
            
            if sharedData == nil || data == nil {
                weakSelf.bagOfSentSharedDataSparseArray[sendCode] = data
                listener?(data)
            }
            
        }
    }
    
    func getSharedDataAlwaysFor(sendCode: AnyHashable, listener: SharedDataListener) -> Disposable {
        return getBaseSharedDataFor(sendCode: sendCode).bind {[weak self] data in
            guard let weakSelf = self else { return }
            weakSelf.bagOfSentSharedDataSparseArray[sendCode] = data
            listener?(data)
        }
    }
}
