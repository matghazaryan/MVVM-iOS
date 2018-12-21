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

class LoginViewModel: BaseViewModel {
    
    private(set) var login: Observable<String>
    private(set) var password: Observable<String>
    private(set) var validFields: Observable<Bool>
    
    private var user: Observable<(login: String, password: String)>
    private(set) var model: Observable<User?>
    private(set) var isChecked: BehaviorRelay<Bool>
    
    
    var rememberMe: Bool {
        set {
            DataRepository.preference().setRememberMe(newValue)
        }
        get {
            return DataRepository.preference().getRememberMe()
        }
    }
    
    required init() {
        login = Observable.just("")
        validFields = Observable.just(false)
        password = Observable.just("")
        user = Observable.just((login: "", password: ""))
        model = Observable.just(nil)
        isChecked = BehaviorRelay(value: false)
    }
    
    func bindForValidation(login: ControlProperty<String?>, password: ControlProperty<String?>) {
        self.login = login.orEmpty
            .share(replay: 1)
        
        self.password = password.orEmpty
            .share(replay: 1)
        
        validFields = Observable.combineLatest(self.login, self.password, resultSelector: { validLogin, validPassword in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: validLogin) && validPassword.count > 8
        })
         user = Observable.combineLatest(login.orEmpty, password.orEmpty, resultSelector: { login, pass in
            return (login: login, password: pass)
         })
    }
    
    func bindToLoginAction(_ tap: ControlEvent<Void>) {
        model = tap.asObservable()
            .withLatestFrom(user)
            .flatMap {login, password -> Observable<User?> in
                return DataRepository.api().login(email: login, password: password)
            }
            .retry()
            .do(onNext: {
                if $0 != nil { // user get successfully
                    if self.isChecked.value == true {
                        DataRepository.preference().setRememberMe(true)
                        self.login.subscribe(onNext: {
                            DataRepository.keychain().saveEmail($0)
                        }).dispose()
                        self.password.subscribe(onNext: {
                            DataRepository.keychain().savePassword($0)
                        }).dispose()
                    }
                }
            })
            .share(replay: 1)
    }
}
