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
        viewModel = SplashViewModel(disposeBag: disposeBag)
        bindViews()
        // Do any additional setup after loading the view.
        viewModel?.getConfigs()
    }
    
    private func bindViews() {
        viewModel?.model
            .subscribe(onNext: { configs in
                if configs != nil {
                    let nextVC: LoginVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
                    UIApplication.shared.keyWindow?.rootViewController = nextVC
                } else {
                    print("configs are nil")
                }
            }, onError: { error in
                print(error)
            }, onDisposed: {
                print("doisposed")
            })
        .disposed(by: disposeBag)
    }
}
