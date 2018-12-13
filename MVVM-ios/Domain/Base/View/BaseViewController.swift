//
//  BaseViewController.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 12/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit
import RxSwift

protocol BaseViewController {

    associatedtype VM: BaseViewModel
    
    var viewModel: VM { set get }
    var disposeBag: DisposeBag { get }
        
}
