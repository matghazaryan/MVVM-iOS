//
//  KeyValueView.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/15/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

class KeyValueView: UIView {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    static func loadFromNib() -> KeyValueView {
        let bundle = Bundle(for: self)
        let view = UINib(nibName: "KeyValueView", bundle: bundle).instantiate(withOwner: nil, options: nil).first as! KeyValueView
        return view
    }

}
