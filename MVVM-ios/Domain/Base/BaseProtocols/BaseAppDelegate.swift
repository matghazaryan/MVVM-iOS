//
//  BaseAppDelegate.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 1/17/19.
//  Copyright © 2019 Matevos Ghazaryan. All rights reserved.
//

import UIKit

protocol BaseAppDelegate: UIApplicationDelegate {
    var congifs: BaseApplicationConfigs { get }
}
