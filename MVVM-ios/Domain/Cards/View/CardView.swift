//
//  CardView.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/19/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

class CardView: UIView {
    @IBOutlet private weak var backgroundView: GradientView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var holderLabel: UILabel!
    
    
    var backgroundGradient: CAGradientLayer! {
        didSet {
            backgroundView.layer.addSublayer(backgroundGradient)
        }
    }
    var cardNumber: String! {
        didSet {
            cardNumberLabel.text = cardNumber
        }
    }
    var date: String! {
        didSet {
            dateLabel.text = date
        }
    }
    var holder: String! {
        didSet {
            holderLabel.text = holder
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        let className = String(describing: self.classForCoder)
        Bundle(for: self.classForCoder).loadNibNamed(className, owner: self, options: nil)
        backgroundView.backgroundColor = .clear
    }
}
