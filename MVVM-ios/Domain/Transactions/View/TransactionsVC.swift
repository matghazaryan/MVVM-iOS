//
//  TransactionsVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional

class TransactionsVC: UITableViewController {
    
    private var viewModel: TransactionViewModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        viewModel = TransactionViewModel(disposeBag: disposeBag)
        tableView.dataSource = nil
        tableView.delegate = nil
        bindViews()
        viewModel?.fetchNext()
    }
    
    private func bindViews() {
        viewModel?.model
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: TransactionCell.reuseIdentifier, cellType: TransactionCell.self)) { index, model, cell in
                let subViews = model.transactionDetails.map({ detail -> KeyValueView in
                    let view = KeyValueView.loadFromNib()
                    view.keyLabel.text = detail.label
                    view.valueLabel.text = detail.value
                    return view
                })
                for subView in subViews {
                    cell.stackView.addArrangedSubview(subView)
                }
            }
            .disposed(by: disposeBag)
        tableView.rx.willDisplayCell.bind {[weak self] cell, indexPath in
            let section = 0
            guard let row = self?.tableView.numberOfRows(inSection: section) else {
                return
            }
            if indexPath == IndexPath(row: row - 1, section: section) {
                self?.viewModel?.fetchNext()
            }
            }
            .disposed(by: disposeBag)
    }
}
