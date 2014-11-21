//
//  Observable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public struct ValueChangedEvent<T> {

}

public struct ValueChange<T> {
    public let oldValue: T
    public let newValue: T
}


public struct Observable<T> {
    public var value: T {
        willSet { willSetValue(newValue, value) }
        didSet { didSetValue(value, oldValue) }
    }

    func willSetValue(newValue: T, _ oldValue: T) {
        ValueChange(oldValue: oldValue, newValue: newValue)
    }

    func didSetValue(newValue: T, _ oldValue: T) {
        ValueChange(oldValue: oldValue, newValue: newValue)
    }

    public init(_ value: T) {
        self.value = value
    }
}
