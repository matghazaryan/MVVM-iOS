//
//  CardsVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CardsVC: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override var updateViewOnLanguageChange: Bool {
        return false
    }
    
    override func viewDidLoad() {
        collectionView.register(CardCollectionViewCell.nib, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getViewModel(as: CardsViewModel.self).getCards()
    }
    
    internal override func bindViews() {
        
        getViewModel(as: CardsViewModel.self).model
            .bind(to: collectionView.rx.items(cellIdentifier: CardCollectionViewCell.reuseIdentifier, cellType: CardCollectionViewCell.self)) { indexPath, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        collectionView.rx.modelSelected(Card.self)
            .subscribe(onNext: {[weak self] card in
                self?.getViewModel(as: CardsViewModel.self).cardSelected(card)
            }, onError: { error in
                UIAlertController.showError(error)
            })
        .disposed(by: disposeBag)
        //change delegate to ourself for manage size of cell
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        (getViewModel(as: CardsViewModel.self).getAction(Action.onCardTap) as Observable<String>)
            .subscribe(onNext: {
                UIAlertController.showAsToastWith(message: $0)
            })
        .disposed(by: disposeBag)
    }

}

extension CardsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 180)
    }
}
