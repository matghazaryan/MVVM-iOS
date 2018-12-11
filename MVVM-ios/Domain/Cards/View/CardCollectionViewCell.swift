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
    var model: Card? {
        didSet {
            bindViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func bindViews() {
        self.cardNumberLabel.text = model?.cardNumber
        self.dateLabel.text = "\(String(describing: model?.expDateMonth))/\(String(describing: model?.expDateYear))"
        self.holderLabel.text = model?.embossingName
        let startColor = UIColor(hexString: (model?.cardColor1).valueOr("FFFFFF"))
        let endColor = UIColor(hexString: (model?.cardColor2).valueOr("FFFFFF"))
        self.cardView.startColor = startColor
        self.cardView.endColor = endColor
    }
}
