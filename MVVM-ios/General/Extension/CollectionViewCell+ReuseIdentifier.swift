//
//  CollectionViewCell+ReuseIdentifier.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/19/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return NSStringFromClass(self)
    }
    
    static var nib: UINib? {
        let bundle = Bundle(for: self)
        let name = self.description().components(separatedBy: ".").last ?? ""
        guard let _ = bundle.path(forResource: name, ofType: ".nib") else {
            return nil
        }
        return UINib(nibName: name, bundle: bundle)
    }
}
