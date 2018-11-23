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
    private var viewModel: LoginViewModel?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = LoginViewModel()
        viewModel?.bindForValidation(login: loginTextField.rx.text, password: passwordTextField.rx.text)
        viewModel?.validFields.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel?.bindToLoginAction(loginButton.rx.tap)
        viewModel?.model.subscribe(onNext: {[weak self] in
            if let user = $0 {
                if self?.checkBox.isChecked == true {
                    self?.viewModel?.rememberMe = true
                    DataRepository.getInstance().saveEmail((self?.loginTextField.text)!)
                    DataRepository.getInstance().savePassword((self?.passwordTextField.text)!)
                }
                let nextVC: AccountVC = UIViewController.instantiateViewControllerForStoryBoardId("Main")
                let viewModel = AccountViewModel(user: user)
                nextVC.viewModel = viewModel
                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: nextVC)
            } else {
                print("error")
            }
        })
        .disposed(by: disposeBag)
    }

}
