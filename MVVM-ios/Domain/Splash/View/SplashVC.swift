//
//  SplashVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SplashVC: UIViewController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getViewModel(as: SplashViewModel.self).getConfigs()
    }
    
    internal override func bindViews() {
        
        (getViewModel(as: SplashViewModel.self).getAction(Action.openAccount) as Observable<User>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] user in
                self?.openAccount(user: user)
            })
            .disposed(by: disposeBag)
        
        (getViewModel(as: SplashViewModel.self).getAction(Action.openLoginVC) as Observable<User?>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.openLogin()
            })
            .disposed(by: disposeBag)
        
        (getViewModel(as: SplashViewModel.self).getAction(Action.showBiometric) as Observable<User?>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.showBiometric()
            })
            .disposed(by: disposeBag)
    }
    
    private func openAccount(user: User) {
        openLogin()
        let nextVC: AccountVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
        let viewModel = AccountViewModel()
        viewModel.setUser(user)
        nextVC.setViewModel(viewModel)
        UIApplication.shared.keyWindow?.rootViewController?.present(UINavigationController(rootViewController: nextVC), animated: true)

    }
    
    private func openLogin() {
        let nextVC: LoginVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }
    
    private func showBiometric() {
        BiometricUtils.authUser(localizedReason: "For Login") { success, error in
            if success {
                self.getViewModel(as: SplashViewModel.self).login()
            } else {
                self.openLogin()
            }
        }
    }
}
