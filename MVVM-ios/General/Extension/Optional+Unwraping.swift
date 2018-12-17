//
//  Optional+Unwraping.swift
//  Wether
//
//  Created by Hovhannes Stepanyan on 10/2/18.
//  Copyright © 2018 Hovhannes Stepanyan. All rights reserved.
//

import Foundation

extension Optional {
    func isNil() -> Bool {
        return self == nil
    }
    
    func notNil() -> Bool {
        return !isNil()
    }
    
    func valueOr(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    func wrapped() -> Wrapped {
        return self!
    }
}
