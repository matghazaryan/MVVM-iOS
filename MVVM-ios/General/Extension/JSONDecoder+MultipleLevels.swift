//
//  JSONDecoder+MultipleLevels.swift
//  LiveNews
//
//  Created by Hovhannes Stepanyan on 8/29/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import Foundation

enum JSONDecodeError {
    case illegalKey(_ key: String)
}

extension JSONDecodeError: LocalizedError {
    var failureReason: String? {
        switch self {
        case .illegalKey(let key):
            return "Illegal Key \(key)"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .illegalKey(let key):
            return "Illegal Key \(key)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .illegalKey(_):
            return "Try to ptint JSON and find legal key"
        }
    }
    
    var helpAnchor: String? {
        switch self {
        case .illegalKey(_):
            return "Try to ptint JSON and find legal key"
        }
    }
}

extension JSONDecoder {
    open func decode<T>(_ type: T.Type, from data: Data, nestedKeys: String...) throws -> T where T : Decodable {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard var jsonDict = json as? [String: Any] else {
            return try decode(T.self, from: data)
        }
        for i in 0..<(nestedKeys.count - 1) {
            let key = nestedKeys[i]
            guard let tempJson = jsonDict[key] as? [String : Any] else {
                throw JSONDecodeError.illegalKey(key)
            }
            jsonDict = tempJson
        }
        let key = nestedKeys.last!
        guard let tempJson = jsonDict[key] else {
            throw JSONDecodeError.illegalKey(key)
        }
        let finalData = try JSONSerialization.data(withJSONObject: tempJson, options: .prettyPrinted)
        return try decode(T.self, from: finalData)
    }
}
