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

class TransactionViewModel {
    private(set) var model: BehaviorRelay<[Transaction]?>
    private(set) var error: PublishSubject<Error?>
    private(set) var hasNextPage = true
    private(set) var currentPage = 1
    private var isLoading = false
    private var disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        model = BehaviorRelay(value: nil)
        error = PublishSubject()
        self.disposeBag = disposeBag
    }
    
    func fetchNext() {
        print("alasad")
        if hasNextPage && !isLoading {
            isLoading = true
            DataRepository.getInstance().getTransactions(page: currentPage)
                .subscribe(onNext: {[weak self] in
                    self?.currentPage += 1
                    self?.hasNextPage = $0.hasNextPage
                    self?.isLoading = false
                    self?.model.accept((self?.model.value).valueOr([Transaction]()) + $0.transactions)
                    }, onError: {[weak self] in
                        self?.error.onNext($0)
                })
                .disposed(by: disposeBag)
        }
    }
}

