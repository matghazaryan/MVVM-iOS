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

    private var viewModel = CardsViewModel()
    private let disposeBag = DisposeBag()
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(CardCollectionViewCell.nib, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
        bindViews()
        viewModel.getCards()
    }
    
    private func bindViews() {
        
        viewModel.model
            .bind(to: collectionView.rx.items(cellIdentifier: CardCollectionViewCell.reuseIdentifier, cellType: CardCollectionViewCell.self)) { indexPath, model, cell in
                cell.model = model
            }
            .disposed(by: disposeBag)
        collectionView.rx.modelSelected(Card.self)
            .subscribe(onNext: {[weak self] card in
                self?.viewModel.cardSelected(card)
            }, onError: { error in
                UIAlertController.showError(error)
            })
        .disposed(by: disposeBag)
        //change delegate to ourself for manage size of cell
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        (viewModel.getAction(Action.onCardTap) as Observable<String>)
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
