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
    let disposeBag = DisposeBag()
    let cellTitles = BehaviorRelay<[String]>(value: [])
    
    init(user: User) {
        email = BehaviorRelay(value: user.email)
    }
    
    func logOut(on tap: ControlEvent<Void>) {
        tap.asObservable()
            .flatMap { _ -> Observable<Void> in
                return DataRepository.getInstance().apiLogOut()
        }
            .retry()
            .subscribe({[weak self] _ in
                DataRepository.getInstance().prefSetRememberMe(false)
                self?.doAction(Action.openLoginVC, param: Optional<Void>(nilLiteral: ()))
            })
            .disposed(by: disposeBag)
    }
}
