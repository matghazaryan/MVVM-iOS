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
    }
    
    private func bindViews() {
        viewModel?.getConfigs()
            .subscribe(onNext: { configs in
                if configs != nil {
                    let nextVC = LoginVC()
                    UIApplication.shared.keyWindow?.rootViewController = nextVC
                } else {
                    print("configs are nil")
                }
            },
                       onError: { error in
                        print(error)
            })
            .disposed(by: disposeBag)
    }
    
}
