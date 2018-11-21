//
//  CardCollectionViewCell.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/19/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var cardView: GradientView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var holderLabel: UILabel!
    var viewModel: CardCellViewModel? {
        didSet {
            bindViews()
        }
    }
    private let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func bindViews() {
        viewModel?.model
            .subscribe(onNext: {[weak self] model in
                self?.cardNumberLabel.text = model.cardNumber
                self?.dateLabel.text = "\(model.expDateMonth)/\(model.expDateYear)"
                self?.holderLabel.text = model.embossingName
                let startColor = UIColor(hexString: model.cardColor1)
                let endColor = UIColor(hexString: model.cardColor2)
                self?.cardView.startColor = startColor
                self?.cardView.endColor = endColor
            })
            .disposed(by: disposeBag)
    }
}
