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
    private(set) var error: PublishSubject<Error?>
    private(set) var hasNextPage = true
    private(set) var currentPage = 1
    private var isLoading = false
    private let disposeBag = DisposeBag()
    
    override init() {
        model = BehaviorRelay(value: nil)
        error = PublishSubject()
    }
    
    func fetchNext() {
        if hasNextPage && !isLoading {
            isLoading = true
            DataRepository.getInstance().apiGetTransactions(page: currentPage)
                .subscribe(onNext: {[weak self] in
                    self?.hasNextPage = $0.hasNextPage
                    if $0.hasNextPage {
                        self?.currentPage += 1
                    }
                    self?.isLoading = false
                    self?.model.accept((self?.model.value).valueOr([TransactionGroup]()) + $0.transactions)
                    }, onError: {[weak self] in
                        self?.error.onNext($0)
                    }, onDisposed: {
                        print("Disposed call on \(TransactionViewModel.self)")
                        print("page = \(self.currentPage)")
                })
                .disposed(by: disposeBag)
        }
    }
}

