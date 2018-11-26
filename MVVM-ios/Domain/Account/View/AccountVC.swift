//
//  AccountVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/12/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class AccountVC: UIViewController {
    
    private enum Indexes: Int {
        case cards = 0
        case transactions = 1
        case settings = 2
    }
    
    private var disposeBag = DisposeBag()
    var viewModel: AccountViewModel?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        bindViews()
        // Do any additional setup after loading the view.
    }
    
    private func bindViews() {
        tableView.rx.itemSelected.bind {[weak self] indexPath in
            guard let vc = self?.viewControllerForIndex(indexPath.row) else {
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        viewModel?.cellTitles
            .bind(to: tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { index, model, cell in
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = model
            }
            .disposed(by: disposeBag)
        viewModel?.model.subscribe(onNext: {[weak self] user in
            self?.nameLabel.text = user?.email
        })
            .disposed(by: disposeBag)
        logOutButton.rx.tap.bind {[weak self] in
            self?.viewModel?.logOut()
            }
            .disposed(by: disposeBag)
        viewModel?.isLogin.subscribe(onNext: {[weak self] logedIn in
            if !logedIn {
                self?.dismiss(animated: true)
            }
        })
            .disposed(by: disposeBag)
    }
    
    private func viewControllerForIndex(_ index: Int) -> UIViewController {
        switch index {
        case Indexes.cards.rawValue:
            let vc: CardsVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
            return vc
        case Indexes.transactions.rawValue:
            let vc: TransactionsVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
            return vc
        case Indexes.settings.rawValue:
            let vc: SettingsVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
            return vc
        default:
            return UIViewController()
        }
    }
    
}
