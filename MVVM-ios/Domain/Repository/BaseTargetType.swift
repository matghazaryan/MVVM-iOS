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
    case transactions(page: Int)
    case cards
}

extension BaseTargetType: TargetType {
    var baseURL: URL {
        return try! "https://www.mocky.io/v2".asURL()
    }
    
    var path: String {
        switch self {
        case .configs:
            return "5bebd4123300006000fbc05c"
        case .login(_, _):
            return "5bebd5603300005900fbc067"
        case .logout:
            return "5bebd5bd3300009500fbc06b"
        case .transactions(let page):
            switch page {
            case 1:
                return "5bec170e330000c825fbc21a"
            case 2:
                return "5bec1769330000ee28fbc21d"
            case 3:
                return "5bec17b0330000c825fbc220"
            case 4:
                return "5bec18173300006125fbc221"
            case 5:
                return "5bec1850330000ee28fbc222"
            case 6:
                return "5bec188c3300002729fbc224"
            case 7:
                return "5bec18be330000cd25fbc227"
            case 8:
                return "5bec19143300007329fbc230"
            default:
                return "5bec194f3300006c29fbc233"
            }
        case .cards:
            return "5bec1fe1330000cd25fbc282"
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
        case .transactions(_):
            return .post
        case .cards:
            return .get
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
        case .transactions(_):
            return "transactions".utf8Encoded
        case .cards:
            return "cards".utf8Encoded
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
        case .transactions(_):
            return nil
        case .cards:
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
