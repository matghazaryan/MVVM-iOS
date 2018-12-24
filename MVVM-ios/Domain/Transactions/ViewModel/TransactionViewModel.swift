//
//  TransactionViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/14/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TransactionViewModel: BaseViewModel {
    private(set) var model: BehaviorRelay<[TransactionGroup]?>
    private(set) var hasNextPage = true
    private(set) var currentPage = 1
    private var isLoading = false
    private let disposeBag = DisposeBag()
    
    required init() {
        model = BehaviorRelay(value: nil)
    }
    
    func fetchNext() {
        if hasNextPage && !isLoading {
            isLoading = true
            showLoading.accept(currentPage == 1)
            DataRepository.api().getTransactions(page: currentPage)
                .subscribe(onNext: {[weak self] in
                    self?.showLoading.accept(false)
                    self?.hasNextPage = $0.hasNextPage
                    if $0.hasNextPage {
                        self?.currentPage += 1
                    }
                    self?.isLoading = false
                    self?.model.accept((self?.model.value).valueOr([TransactionGroup]()) + $0.transactions)
                    }, onError: {[weak self] in
                        self?.showLoading.accept(false)
                        self?.doAction(Action.openErrorDialog, param: $0)
                    }, onDisposed: {
                        print("Disposed call on \(TransactionViewModel.self)")
                        print("page = \(self.currentPage)")
                })
                .disposed(by: disposeBag)
        }
    }
}

