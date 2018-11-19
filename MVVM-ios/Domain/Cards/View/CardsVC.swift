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
                cell.cardNumberLabel.text = model.cardNumber
                cell.dateLabel.text = "\(model.expDateMonth)/\(model.expDateYear)"
                cell.holderLabel.text = model.embossingName
                let startColor = UIColor(hexString: model.cardColor1)
                let endColor = UIColor(hexString: model.cardColor2)
                cell.cardView.startColor = startColor
                cell.cardView.endColor = endColor
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

}

extension CardsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 180)
    }
}
