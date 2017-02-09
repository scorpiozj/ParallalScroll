//
//  Constants.swift
//  NestedScrollView
//
//  Created by ZhuJiang on 17/1/8.
//  Copyright © 2017年 Charles. All rights reserved.
//

import Foundation
import CoreGraphics

struct ZZConstrants {
    
    static let Pull_Threshold: CGFloat = 100.0
    
    static let appName     = "Test"
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        static let Tmp = NSTemporaryDirectory()
    }
    
    
}
///https://gist.github.com/Abizern/a81f31a75e1ad98ff80d
func ZZDebugLog<T>(object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String
        
        if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        } else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        } else {
            fatalError("loggingPrint only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
        }
        
        let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(fileURL) \(function)[\(line)]: " + stringRepresentation)
    #endif
}
