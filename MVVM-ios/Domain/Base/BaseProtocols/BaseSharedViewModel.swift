//
//  BaseSharedViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/17/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift

protocol BaseSharedViewModel {
    associatedtype SharedData
    typealias SharedDataListener = Optional<((SharedData?) -> Void)>
    
    func sendSharedDataWith(sendCode: AnyHashable, data: SharedData?)
    func getSharedDataFor(sendCode: AnyHashable, listener: SharedDataListener) -> Disposable
    func getSharedDataAlwaysFor(sendCode: AnyHashable, listener: SharedDataListener) -> Disposable
}
