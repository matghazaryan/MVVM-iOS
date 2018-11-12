//
//  TableViewCell+ReuseIdentifier.swift
//  Wether
//
//  Created by Hovhannes Stepanyan on 10/3/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import UIKit

extension UITableViewCell {

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
