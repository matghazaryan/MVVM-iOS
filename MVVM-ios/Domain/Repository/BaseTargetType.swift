//
//  BaseTargetType.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/7/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import Moya

enum BaseTargetType {
    case configs
}

extension BaseTargetType: TargetType {
    var baseURL: URL {
        return try! "https://test-arca.helix.am".asURL()
    }
    
    var path: String {
        switch self {
        case .configs:
            return "config"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .configs:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .configs:
            return "".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .configs:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .configs:
            return nil
        }
    }
    
    
}
