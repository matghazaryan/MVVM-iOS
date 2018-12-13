//
//  UIViewController+Swizzling.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

private let swizzling: (UIViewController.Type) -> () = { viewController in
    let oldSelector = #selector(viewController.viewDidLoad)
    let newSelector = #selector(viewController.proj_viewDidLoad)
    
    guard let old = class_getInstanceMethod(viewController, oldSelector),
        let new = class_getInstanceMethod(viewController, newSelector) else { return }
    
    method_exchangeImplementations(old, new)
}

@objc
extension UIViewController {
    open class func initializeing() {
        // make sure this isn't a subclass
        guard self === UIViewController.self else { return }
        swizzling(self)
    }
    
    // MARK: - Method Swizzling
    @objc func proj_viewDidLoad() {
        self.proj_viewDidLoad()
        
        let viewControllerName = NSStringFromClass(type(of: self))
        print("ViewDidLoad called on \(viewControllerName)")
        #warning("init viewModel, do other staff relative to binding before call super.viewDidLoad()")
        bindViews()
        NotificationCenter.default
        .addObserver(self,
                     selector: #selector(onLanguageChange(_:)),
                     name: languageChangeNotification, object: nil)
    }
    
    func bindViews() { }
    func onLanguageChange(_ note: Notification) {
        // any additioal steps every time when language changes
    }
}
