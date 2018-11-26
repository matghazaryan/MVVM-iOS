//
//  SettingViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/22/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingViewModel {
    var imageData: BehaviorRelay<Data?>
    var buttonTap = PublishRelay<Void>()
    
    init() {
        imageData = BehaviorRelay(value: nil)
    }
    
    func setImageData(_ data: Data?) {
        imageData.accept(data)
    }
    
    func uploadFile() -> PublishRelay<Void> {
        print("file upload.....")
        return PublishRelay<Void>()
    }
}
