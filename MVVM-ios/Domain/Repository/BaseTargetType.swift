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
    case login(email: String, password: String)
    case logout
}

extension BaseTargetType: TargetType {
    var baseURL: URL {
        return try! "https://test-arca.helix.am/api/en".asURL()
    }
    
    var path: String {
        switch self {
        case .configs:
            return "config"
        case .login(_, _):
            return "login"
        case .logout:
            return "logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .configs:
            return .get
        case .login(_, _):
            return .post
        case .logout:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .configs:
            return "".utf8Encoded
        case .login(_, _):
            return "login".utf8Encoded
        case .logout:
            return "logout".utf8Encoded
        }
    }
    
    var task: Task {
        var params = [String: Any]()
        params["deviceType"] = "iPhone"
        params["applicationId"] = BaseTargetType.getUDID()
        params["applicationVersion"] = BaseTargetType.getApplicationVersionNumber()
        params["deviceScale"] = BaseTargetType.getDeviceScale()
        params["jwt"] = DataRepository.getInstance().getToken()
        switch self {
        case .login(let email, let password):
            params["email"] = email
            params["password"] = password
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
        default:
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .configs:
            return nil
        case .login(_, _):
            return nil
        case .logout:
            return nil
        }
    }
    
    static func getUDID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    static func getApplicationVersionNumber() -> String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!
    }
    
    static func getDeviceScale() -> String {
        return String(describing: UIScreen.main.scale)
    }
}
