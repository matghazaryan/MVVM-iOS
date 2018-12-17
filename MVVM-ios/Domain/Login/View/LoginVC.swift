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

class LoginVC: UIViewController, BaseViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkBox: CheckBox!
    internal var viewModel: LoginViewModel = LoginViewModel()
    internal let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        loginTextField.keyboardType = .emailAddress
        loginTextField.text = "as@ss.sa"
        passwordTextField.text = "adkjfewhuvwjhebkwe"
        // Do any additional setup after loading the view.
        super.viewDidLoad()
    }
    
    internal override func bindViews() {
        viewModel.bindForValidation(login: loginTextField.rx.text, password: passwordTextField.rx.text)
        viewModel.validFields.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.bindToLoginAction(loginButton.rx.tap)
        checkBox.onCheckChange.asObservable().bind(to: viewModel.isChecked).disposed(by: disposeBag)
        
        viewModel.model.subscribe(onNext: {
            if let user = $0 {
                let nextVC: AccountVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
                let viewModel = AccountViewModel(user: user)
                nextVC.viewModel = viewModel
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
    
    override func onLanguageChange(_ note: Notification) {
        self.view = nil
        self.viewWillAppear(true)
    }

}
