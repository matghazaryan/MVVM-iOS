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
    @IBOutlet weak var checkBox: CheckBox!
    
    override func viewDidLoad() {
        loginTextField.keyboardType = .emailAddress
        loginTextField.text = "as@ss.sa"
        passwordTextField.text = "adkjfewhuvwjhebkwe"
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    
    internal override func bindViews() {
        getViewModel(as: LoginViewModel.self).bindForValidation(login: loginTextField.rx.text, password: passwordTextField.rx.text)
        getViewModel(as: LoginViewModel.self).validFields.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        getViewModel(as: LoginViewModel.self).bindToLoginAction(loginButton.rx.tap)
        checkBox.onCheckChange.asObservable().bind(to: getViewModel(as: LoginViewModel.self).isChecked).disposed(by: disposeBag)
        
        getViewModel(as: LoginViewModel.self).model.subscribe(onNext: {
            if let user = $0 {
                let nextVC: AccountVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
                let viewModel = AccountViewModel()
                viewModel.setUser(user)
                nextVC.setViewModel(viewModel)
                UIApplication.shared.keyWindow?.rootViewController?
                    .present(UINavigationController(rootViewController: nextVC),
                             animated: false,
                             completion: nil)
            } else {
                print("error")
            }
        })
            .disposed(by: disposeBag)
    }

}
