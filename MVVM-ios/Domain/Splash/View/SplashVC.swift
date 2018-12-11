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
    
    let disposeBag = DisposeBag()
    var viewModel: SplashViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SplashViewModel()
        bindViews()
        // Do any additional setup after loading the view.
        viewModel?.getConfigs()
    }
    
    private func bindViews() {
        guard let viewModel = self.viewModel else {
            return
        }
        (viewModel.getAction(Action.doLogin) as Observable<User>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { _ in
                viewModel.login()
            })
            .disposed(by: disposeBag)
        
        (viewModel.getAction(Action.openAccount) as Observable<User>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] user in
                self?.openAccount(user: user)
            })
            .disposed(by: disposeBag)
        
        (viewModel.getAction(Action.openLoginVC) as Observable<User?>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.openLogin()
            })
            .disposed(by: disposeBag)
        
        (viewModel.getAction(Action.showBiometric) as Observable<User?>)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {[weak self] _ in
                self?.showBiometric()
            })
            .disposed(by: disposeBag)
        
        viewModel.error.subscribe(onNext: { error in
            print(error?.localizedDescription)
        })
        .disposed(by: disposeBag)
    }
    
    private func openAccount(user: User) {
        openLogin()
        let nextVC: AccountVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
        let viewModel = AccountViewModel(user: user)
        nextVC.viewModel = viewModel
        UIApplication.shared.keyWindow?.rootViewController?.present(UINavigationController(rootViewController: nextVC), animated: true)
    }
    
    private func openLogin() {
        let nextVC: LoginVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
        UIApplication.shared.keyWindow?.rootViewController = nextVC
    }
    
    private func showBiometric() {
        BiometricUtils.authUser(localizedReason: "For Login") { success, error in
            if success {
                self.viewModel?.login()
            } else {
                self.openLogin()
            }
        }
    }
}
