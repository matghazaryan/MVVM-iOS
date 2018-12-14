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

class SettingViewModel: BaseViewModel {
    var imageData: BehaviorRelay<Data?>
    var successUpload: Observable<Bool>
    
    override init() {
        imageData = BehaviorRelay(value: nil)
        successUpload = Observable<Bool>.just(false)
    }
    
    func setImageData(_ data: Data?) {
        imageData.accept(data)
    }
    
    func bindToUpload(_ tap: ControlEvent<Void>) {
        successUpload = tap.asObservable()
            .withLatestFrom(imageData)
            .flatMap({ data -> Observable<Bool> in
                guard let data = data else {
                    return Observable.just(false)
                }
                print("file upload...")
                return DataRepository.api().uploadImage(data)
                .map({ response -> Bool in
                    return response.completed
                })
            })
            .retry()
            .share(replay: 1)
    }
}
