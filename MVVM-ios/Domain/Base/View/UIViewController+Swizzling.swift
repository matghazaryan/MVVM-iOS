//
//  UIViewController+Swizzling.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

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
    
    /// disposeBag for use in binding .dispose(by: disposeBag)
    var disposeBag: DisposeBag {
        get {
            guard let disposeBag =  objc_getAssociatedObject(self, &AssociatedObjectKeys.disposeBag) as? DisposeBag else {
                let db = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedObjectKeys.disposeBag, db, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return db
            }
            return disposeBag
        }
    }
    
    /** override var and return false in all custom viewControllers which you want to not update view
        after language chang
     - Note: default value is true
     */
    @objc var updateViewOnLanguageChange: Bool {
        return true
    }
    
    
    /**
 swizzle viewDidLoad() method for make some required steps, automaticly call bindings and subscribe on notification
 - Note: call in appDelegate
 */
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
        baseBinding()
        NotificationCenter.default
        .addObserver(self,
                     selector: #selector(onLanguageChange(_:)),
                     name: languageChangeNotification, object: nil)
    }
    
    /// override to do view bindings
    @objc func bindViews() { }
    
    /// any additional steps after language change
    @objc func onLanguageChange(_ note: Notification) {
        // any additioal steps every time when language changes
        let moduleName = NSStringFromClass(self.classForCoder).split(separator: ".").first
        if updateViewOnLanguageChange && (moduleName?.contains("MVVM")).valueOr(false) {
            self.view = nil
            let _ = self.view
            self.viewWillAppear(true)
        }
    }
    
    private func baseBinding() {
        (getViewModel(as: BaseViewModel.self).getAction(Action.openErrorDialog) as Observable<Error>)
            .subscribe(onNext: {
                UIAlertController.showError($0)
            })
            .disposed(by: disposeBag)
        (getViewModel(as: BaseViewModel.self).getAction(Action.showNoInternet) as Observable<String>)
            .subscribe(onNext: {
                UIAlertController.showWith(message: $0)
            })
            .disposed(by: disposeBag)
        getViewModel(as: BaseViewModel.self).showLoading
            .subscribe(onNext: {[weak self] in
                guard let `self` = self else { return }
                if $0 {
                    let loadingVC = BaseLoadingVC()
                    loadingVC.loadingView = NVActivityIndicatorView(
                        frame: CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0),
                        type: NVActivityIndicatorType.lineScale,
                        color: UIColor.blue,
                        padding: 0.0)
                    self.addChildViewController(loadingVC, to: self.view)
                } else {
                    for child in self.children {
                        if child is BaseLoadingVC {
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                        }
                    }
                }
            })
        .disposed(by: disposeBag)
    }
    
    
    /**
     - Note:
     you must write an appropriate argument as the corresponding class
     as otherwise it will turn out class cast exception later
    
     - Parameter clazz: Class of ViewModel which you want to get
    
     - Returns: viewModel of your ViwController
    */
    func getViewModel<T: BaseViewModel>(as clazz: T.Type) -> T {
        guard let vm = objc_getAssociatedObject(self, &AssociatedObjectKeys.viewModel) as? T
            else {
                let vm = T()
                objc_setAssociatedObject(self, &AssociatedObjectKeys.viewModel, vm, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return vm
        }
        return vm
    }
    
    /**
    for cases if we need to set viewModel out of our viewController
     - Parameter vm: viewMOdel of viewController
 */
    func setViewModel(_ vm: BaseViewModel) {
        objc_setAssociatedObject(self, &AssociatedObjectKeys.viewModel, vm, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// for easy set navigation title
    /// - Parameter title: the title of navigation item
    func setNavigationTitle(_ navigationTitle: String?) {
        navigationItem.title = navigationTitle
    }
}

extension NVActivityIndicatorView: LoadingView {
    func startAnimate() {
        self.startAnimating()
    }
    
    func endAnimate() {
        self.stopAnimating()
    }
}
