//
//  CardsViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CardsViewModel {
    private(set) var model: BehaviorRelay<[BehaviorRelay<Card>]>
    private var disposeBag = DisposeBag()
    
    init() {
        model = BehaviorRelay(value: [])
    }
    
    func getCards() {
        DataRepository.getInstance()
            .apiGetCards().subscribe(onNext: {
                self.model.accept($0.map {
                    BehaviorRelay(value: $0)
                })
            }, onDisposed: {
                print("\(self) disposed")
            })
            .disposed(by: disposeBag)
    }
}
