//
//  UIStackView+Extensions.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/21/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        for subView in self.arrangedSubviews {
            self.removeArrangedSubview(subView)
        }
    }
}
