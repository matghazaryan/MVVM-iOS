//
//  String+NS.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/13/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import Foundation

extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    static func path(withComponents components: [String]) -> String {
        return NSString.path(withComponents: components)
    }
    
    var pathComponents: [String] {
        
        return (self as NSString).pathComponents
    }
    
    var isAbsolutePath: Bool {
        return (self as NSString).isAbsolutePath
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var abbreviatingWithTildeInPath: String {
        return (self as NSString).abbreviatingWithTildeInPath
    }
    
    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
    
    func appendingPathExtension(_ str: String) -> String? {
        return (self as NSString).appendingPathExtension(str)
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var expandingTildeInPath: String {
        return (self as NSString).expandingTildeInPath
    }
    
    var resolvingSymlinksInPath: String {
        return (self as NSString).resolvingSymlinksInPath
    }
    
    var standardizingPath: String {
        return (self as NSString).standardizingPath
    }
    
    func strings(byAppendingPaths paths: [String]) -> [String] {
        return (self as NSString).strings(byAppendingPaths: paths)
    }
}
