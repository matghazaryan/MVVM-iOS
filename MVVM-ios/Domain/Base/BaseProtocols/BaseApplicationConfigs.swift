//
//  BaseApplicationConfigs.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/17/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import Foundation

enum BaseAction: Hashable {
    case openErrorDialog
    case showNoInternet
}

protocol BaseApplicationConfigs {
    /**
     * General error message , which show when can not find another error message for current error case , then show general message
     */
    var errorMessage: String? { get }
    
    /**
     * No internet error message
     */
    var noInternetMessage: String? { get }
}
