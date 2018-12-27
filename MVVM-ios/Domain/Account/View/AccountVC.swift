//
//  AccountVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/12/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa


class AccountVC: UIViewController {
    
    private enum Indexes: Int {
        case cards = 0
        case transactions = 1
        case settings = 2
    }
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        navigationItem.title = "Account".localized
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = DataRepository.preference().getAvatarURL() else {
            userImage.image = #imageLiteral(resourceName: "avatar")
            return
        }
        let asset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
        guard let result = asset.firstObject else {
            userImage.image = #imageLiteral(resourceName: "avatar")
            return
        }
        let imageManager = PHImageManager.default()
        imageManager.requestImageData(for: result, options: nil) { data, string, orientation, dict in
            guard let data = data else {
                return
            }
            let image = UIImage(data: data)
            self.userImage.image = image
        }
    }
    
    internal override func bindViews() {
        tableView.rx.itemSelected.bind {[weak self] indexPath in
            guard let vc = self?.viewControllerForIndex(indexPath.row) else {
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        getViewModel(as: AccountViewModel.self).cellTitles
            .bind(to: tableView.rx.items(cellIdentifier: UITableViewCell.reuseIdentifier, cellType: UITableViewCell.self)) { index, model, cell in
                cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = model
            }
            .disposed(by: disposeBag)
        getViewModel(as: AccountViewModel.self).email
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        getViewModel(as: AccountViewModel.self).logOut(on: logOutButton.rx.tap).subscribe().disposed(by: disposeBag)
        (getViewModel(as: AccountViewModel.self).getAction(Action.openLoginVC) as Observable<Void?>)
            .subscribe({[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func onLanguageChange(_ note: Notification) {
        super.onLanguageChange(note)
        getViewModel(as: AccountViewModel.self).onLanguageChange()
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

