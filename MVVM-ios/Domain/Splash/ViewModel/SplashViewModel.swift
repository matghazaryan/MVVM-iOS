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
    
    private(set) var model: Configs?
    private(set) var disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func getConfigs() -> Observable<Configs?> {
        return DataRepository.getInstance().getConfigs()
    }
}
