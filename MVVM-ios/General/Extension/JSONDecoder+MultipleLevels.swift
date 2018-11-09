//
//  JSONDecoder+MultipleLevels.swift
//  LiveNews
//
//  Created by Hovhannes Stepanyan on 8/29/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import Foundation

extension JSONDecoder {
    open func decode<T>(_ type: T.Type, from data: Data, nestedKeys: String...) throws -> T where T : Decodable {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        var tempJson: Any? = nil
        if var jsonDict = json as? [String: Any] {
            for i in 0..<(nestedKeys.count - 1) {
                let key = nestedKeys[i]
                tempJson = jsonDict[key] as? [String : Any]
                if tempJson == nil {
                    throw NSException(name: NSExceptionName.genericException, reason: "Illegal Key \(key)", userInfo: nil) as! Error
                } else {
                    jsonDict = tempJson as! [String: Any]
                }
            }
            let key = nestedKeys.last
            tempJson = jsonDict[key!] as Any
            if tempJson == nil {
                throw NSException(name: NSExceptionName.genericException, reason: "Illegal Key \(key ?? "")", userInfo: nil) as! Error
            }
        }
        let finalData = try JSONSerialization.data(withJSONObject: tempJson!, options: .prettyPrinted)
        return try decode(T.self, from: finalData)
    }
}
