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

class AccountViewModel {
    
    var model: BehaviorRelay<User?>
    let isLogin: PublishRelay<Bool> = PublishRelay()
    let disposeBag = DisposeBag()
    let cellTitles = BehaviorRelay<[String]>(value: ["Cards".localized, "Transactions".localized, "Settings".localized])
    
    init(user: User) {
        model = BehaviorRelay(value: user)
        isLogin.accept(true)
    }
    
    func logOut() {
        DataRepository.getInstance().apiLogOut().subscribe(onNext: {
            self.isLogin.accept(!$0)
        })
            .disposed(by: disposeBag)
    }
}
