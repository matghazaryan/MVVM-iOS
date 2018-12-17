//
//  UIViewController+StoryBoard.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/9/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateViewControllerForStoryBoardId<T>(_ name: String) -> T {
        let type = T.self
        let className = String(describing: type)
        let bundle = Bundle(for: type as! AnyClass)
        let storyBoard = UIStoryboard(name: name, bundle: bundle)
        return storyBoard.instantiateViewController(withIdentifier: className) as! T
    }
}
