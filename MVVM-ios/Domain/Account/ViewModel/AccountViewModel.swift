//
//  AccountViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/12/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class AccountViewModel: BaseViewModel {
    
    var email: BehaviorRelay<String?>
    let cellTitles = BehaviorRelay<[String]>(value: [])
    
    required init() {
        email = BehaviorRelay(value: nil)
        cellTitles.accept(["Cards".localized, "Transactions".localized, "Settings".localized])
    }
    
    func setUser(_ user: User) {
        email.accept(user.email)
    }
    
    func logOut(on tap: ControlEvent<Void>) -> Observable<()> {
        return tap.asObservable()
            .flatMap { _ -> Observable<Void> in
                return DataRepository.api().logOut()
            }
            .retry()
            .do(onNext: {[weak self] _ in
                DataRepository.preference().setRememberMe(false)
                self?.doAction(Action.openLoginVC, param: Optional<Void>(nilLiteral: ()))
                if !CoreDataManager.clearDataBase(Card.self) {
                    print("database was not cleared")
                }
                }, onError: {[weak self] error in
                    self?.doAction(BaseAction.openErrorDialog, param: error)
            })
    }
    
    func onLanguageChange() {
        cellTitles.accept(["Cards".localized, "Transactions".localized, "Settings".localized])
    }
}
