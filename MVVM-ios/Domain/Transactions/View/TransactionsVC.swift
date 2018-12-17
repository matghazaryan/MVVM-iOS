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
import RxDataSources

class TransactionsVC: UITableViewController, BaseViewController {
    var viewModel: TransactionViewModel = TransactionViewModel()
    
    var disposeBag = DisposeBag()
    
    
    

    override func viewDidLoad() {
        tableView.register(TransactionCell.nib, forCellReuseIdentifier: TransactionCell.reuseIdentifier)
        tableView.dataSource = nil
        tableView.delegate = nil
        super.viewDidLoad()
        viewModel.fetchNext()
    }
    
    internal override func bindViews() {
        let rxDataSource = RxTableViewSectionedReloadDataSource<TransactionSectionModel>(configureCell: { dataSource, tableView, indexPath, model -> TransactionCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.reuseIdentifier, for: indexPath) as! TransactionCell
            let subViews = model.transactionList.map({ detail -> KeyValueView in
                let view = KeyValueView.loadFromNib()
                view.keyLabel.text = detail.label
                view.valueLabel.text = detail.value
                return view
            })
            for subView in subViews {
                cell.stackView.addArrangedSubview(subView)
            }
            return cell
        })
        
        
        viewModel.model
            .filterNil()
            .map({ transaction -> [TransactionSectionModel] in
                let x = transaction.map({
                    TransactionSectionModel(items: [$0])
                })
                return x
            })
            .bind(to: tableView.rx.items(dataSource: rxDataSource))
            .disposed(by: disposeBag)
        tableView.rx.willDisplayCell.bind {[weak self] cell, indexPath in
            guard let section = self?.tableView.numberOfSections,
                let row = self?.tableView.numberOfRows(inSection: section - 1) else {
                    return
            }
            if indexPath == IndexPath(row: row - 1, section: section - 1) {
                self?.viewModel.fetchNext()
            }
            }
            .disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { error in
            UIAlertController.showError(error)
        })
        .disposed(by: disposeBag)
    }
}
