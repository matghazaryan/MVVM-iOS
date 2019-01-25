//
//  DisposeBag+extensions.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/25/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import RxSwift

extension DisposeBag {
    func disposeAll() {
        let mirror = Mirror(reflecting: self)
        for (_, value) in mirror.children {
            if let disposables = value as? [Disposable] {
                for disposable in disposables {
                    disposable.dispose()
                }
            }
        }
    }
}
