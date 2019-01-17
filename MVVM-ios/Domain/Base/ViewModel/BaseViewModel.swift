//
//  BaseViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/10/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Action: Hashable {
    case openAccount
    case showBiometric
    case openLoginVC
    case doLogin
    case ON_NEW_IMAGE_PATH
    case onCardTap
}

class BaseViewModel {
    private var observablesDict = [AnyHashable: Any]()
    private var reachibility = Reachability()
    /// indicate that viewModel is loading data and need to show loading view
    var showLoading: BehaviorRelay = BehaviorRelay(value: false)
    
    /// Get action and subscribe in viewController
    /// - Parameter action: action to get observable
    public func getAction<T>(_ action: AnyHashable) -> Observable<T> {
        guard let data = observablesDict[action] else {
            let observable = PublishRelay<T>()
            observablesDict[action] = observable
            return observable.asObservable()
        }
        return (data as! PublishRelay<T>).asObservable()
    }
    
    /// say viewController to do some action
    /// - Parameter action: action whish must emited
    /// - Parameter param: param which passed to observable
    public func doAction<T>(_ action: AnyHashable, param: T?) {
        guard let data =  observablesDict[action] else {
            let observable = PublishRelay<T?>()
            observablesDict[action] = observable
            observable.accept(param)
            return
        }
        if let param = param {
            (data as! PublishRelay<T>).accept(param)
        } else {
            (data as! PublishRelay<T?>).accept(param)
        }
    }
    
    /// General error handling
    /// - Parameter error: error for handling
    func handleError(_ error: Error) {
        
    }
    
    /// override and write retry logic here
    func retry() {
        
    }
    
    required init() {
        reachibility?.whenUnreachable = {[weak self] _ in
            self?.doAction(BaseAction.showNoInternet, param: Optional<Void>(nilLiteral: ()))
        }
        reachibility?.whenReachable = {[weak self] _ in
            self?.retry()
        }
    }
    
    private func isOptional<T>(_ type: T) -> Bool {
        let typeName = String(describing: type)
        return typeName.hasPrefix("Optional") || typeName.hasPrefix("nil")
    }
}
