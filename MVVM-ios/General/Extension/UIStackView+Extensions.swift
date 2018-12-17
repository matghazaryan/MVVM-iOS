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
        let removedSubviews = self.arrangedSubviews.reduce([]) { allSubviews, subview -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactive all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
