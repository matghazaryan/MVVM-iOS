//
//  UIViewController+Swizzling.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift

private let swizzling: (UIViewController.Type) -> () = { viewController in
    let oldSelector = #selector(viewController.viewDidLoad)
    let newSelector = #selector(viewController.proj_viewDidLoad)
    
    guard let old = class_getInstanceMethod(viewController, oldSelector),
        let new = class_getInstanceMethod(viewController, newSelector) else { return }
    
    method_exchangeImplementations(old, new)
}

extension UIViewController {
    private struct AssociatedObjectKeys {
        static var viewModel = 0
        static var disposeBag = 1
    }
    
    @objc var viewmodelClass: AnyClass {
        return BaseViewModel.self
    }
    
    internal var viewModel: BaseViewModel {
        set {
            let vm = viewmodelClass.init()
            objc_setAssociatedObject(self, &AssociatedObjectKeys.viewModel, vm, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKeys.viewModel)
        }
    }
    
    var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKeys.disposeBag, DisposeBag(), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKeys.disposeBag)
        }
    }
    
    @objc var updateViewOnLanguageChange: Bool {
        return false
    }
    
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
    
    @objc func bindViews() { }
    @objc func onLanguageChange(_ note: Notification) {
        // any additioal steps every time when language changes
        if updateViewOnLanguageChange {
            self.view = nil
            let _ = self.view
            self.viewWillAppear(true)
        }
    }
    
    private func baseBinding() {
        (viewModel.getAction(Action.openErrorDialog) as Observable<Error>)
            .subscribe(onNext: {
                UIAlertController.showError($0)
            })
            .disposed(by: disposeBag)
        (viewModel.getAction(Action.showNoInternet) as Observable<String>)
            .subscribe(onNext: {
                UIAlertController.showWith(message: $0)
            })
            .disposed(by: disposeBag)
    }
    
    func getViewModel<T>(as clazz: T.Type) -> T {
        if viewModel is T {
            return viewModel as! T
        } else {
            fatalError()
        }
    }
    
    func setNavigationTitle(_ navigationTitle: String?) {
        navigationItem.title = navigationTitle
    }
}
