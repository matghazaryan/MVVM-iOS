//
//  BiometricUtils.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/19/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation
import LocalAuthentication

struct BiometricUtils {
    public enum BiometrivType {
        case none, touchID, faceID
    }
    
    static func biometricType() -> BiometrivType {
        let authContext = LAContext()
        var error: NSError?
        let canEvaluate = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11.0, *) {
            switch authContext.biometryType {
            case .faceID:
                return .faceID
            case .touchID:
                return .touchID
            case .none:
                return .none
            }
        } else {
            #if TARGET_OS_SIMULATOR
            return .none
            #else
            return canEvaluate ? .touchID : .none
            #endif
        }
    }
    
    static func authUser(localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) {
                reply($0, $1)
            }
        } else {
            reply(false, error)
        }
    }
}
