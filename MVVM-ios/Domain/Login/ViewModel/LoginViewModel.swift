//
//  LoginViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/9/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

struct LoginViewModel {
    
    private(set) var validLogin: Observable<Bool>
    private(set) var validPassword: Observable<Bool>
    private(set) var validFields: Observable<Bool>
    private(set) var disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        validLogin = Observable.just(false)
        validFields = Observable.just(false)
        validPassword = Observable.just(false)
        self.disposeBag = disposeBag
    }
    
    mutating func bindForValidation(login: ControlProperty<String?>, password: ControlProperty<String?>) {
        validLogin = login.orEmpty
            .map({ string -> Bool in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                return emailTest.evaluate(with: string)
            })
            .share(replay: 1)
        
        validPassword = password.orEmpty
            .map({ string -> Bool in
                return string.count > 8
            })
            .share(replay: 1)
        
        validFields = Observable.combineLatest(validLogin, validPassword, resultSelector: { validLogin, validPassword in
            return validLogin && validPassword
        })
    }
    
    func doLogin(login: String, password: String) -> Observable<User?> {
        return DataRepository.getInstance().login(email: login, password: password)
    }
}
