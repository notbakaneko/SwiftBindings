//
//  ValueChange.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public protocol AnyValueChange {
    typealias ValueType
    var oldValue: ValueType { get }
    var newValue: ValueType { get }
}

public struct ValueChange<T> : AnyValueChange {
    typealias ValueType = T
    public let oldValue: ValueType
    public let newValue: ValueType
}
