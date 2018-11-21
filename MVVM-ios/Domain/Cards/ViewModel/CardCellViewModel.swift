//
//  CardCellViewModel.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/21/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CardCellViewModel {
    private(set) var model: BehaviorRelay<Card>
    init(model: BehaviorRelay<Card>) {
        self.model = model
    }
}
