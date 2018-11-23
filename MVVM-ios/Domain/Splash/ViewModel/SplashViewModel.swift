//
//  SplashViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SplashViewModel {
    
    private(set) var configs: BehaviorRelay<Configs?>
    private(set) var user: PublishRelay<User?>
    private(set) var error: PublishRelay<Error?>
    private(set) var disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        configs = BehaviorRelay(value: nil)
        user = PublishRelay()
        error = PublishRelay()
    }
    
    func getConfigs() {
        DataRepository.getInstance().apiGetConfigs()
            .subscribe(onNext: {
                self.configs.accept($0)
                self.login()
            })
            .disposed(by: disposeBag)
    }
    
    func login() {
        if DataRepository.getInstance().prefGetRememberMe() {
            guard let email = DataRepository.getInstance().getEmail(),
                let password = DataRepository.getInstance().getPassword() else {
                    user.accept(nil)
                    return
            }
            DataRepository.getInstance().apiLogin(email: email, password: password)
                .subscribe(onNext: {
                    self.user.accept($0)
                }, onError: {
                    self.error.accept($0)
                })
                .disposed(by: disposeBag)
        } else {
            user.accept(nil)
        }
    }
}
