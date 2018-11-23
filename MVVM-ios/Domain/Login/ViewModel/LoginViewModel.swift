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
    private var user: Observable<(login: String, password: String)>
    private(set) var model: Observable<User?>
    
    
    var rememberMe: Bool {
        set {
            DataRepository.getInstance().prefSetRememberMe(newValue)
        }
        get {
            return DataRepository.getInstance().prefGetRememberMe()
        }
    }
    
    init() {
        validLogin = Observable.just(false)
        validFields = Observable.just(false)
        validPassword = Observable.just(false)
        user = Observable.just((login: "", password: ""))
        model = Observable.just(nil)
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
         user = Observable.combineLatest(login.orEmpty, password.orEmpty, resultSelector: { login, pass in
            return (login: login, password: pass)
         })
    }
    
    mutating func bindToLoginAction(_ tap: ControlEvent<Void>) {
        model = tap.asObservable()
            .withLatestFrom(user)
            .flatMap {login, password -> Observable<User?> in
                return DataRepository.getInstance().apiLogin(email: login, password: password)
            }
            .retry()
            .share(replay: 1)
    }
}
