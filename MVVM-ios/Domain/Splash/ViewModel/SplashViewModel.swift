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
    
    private(set) var model: BehaviorRelay<Configs?>
    private(set) var error: PublishRelay<Error?>
    private(set) var disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        model = BehaviorRelay(value: nil)
        error = PublishRelay()
    }
    
    func getConfigs() {
        DataRepository.getInstance().getConfigs()
            .subscribe(onNext: {
                self.model.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
