//
//  LoginVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var viewModel: LoginViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = LoginViewModel(disposeBag: disposeBag)
        viewModel?.bindForValidation(login: loginTextField.rx.text, password: passwordTextField.rx.text)
        viewModel?.validFields.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginButton.rx.tap.subscribe({ [weak self] _ in
            self?.viewModel?.doLogin(login: (self?.loginTextField.text)!, password: (self?.passwordTextField.text)!)
            .subscribe(onNext: {
                print($0 != nil ? "\($0)" : "error")
            })
            .disposed(by: (self?.disposeBag)!)
        }).disposed(by: disposeBag)
    }

}
