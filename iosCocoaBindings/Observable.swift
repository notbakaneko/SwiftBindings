//
//  Observable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public struct ValueChange<T> {
    public let oldValue: T
    public let newValue: T
}


public protocol AnyObservable {
    func subscribe(subscriber: Any)
    func unsubscribe(subscriber: Any)
}

class Subscribers {
    private var observers = [Any]()

    init() {}

    func append(subscriber: Any) {
        observers.append(subscriber)
    }

    func remove(subscriber: Any) {

    }

    func notifyWillChange<T>(event: ValueChange<T>) {

    }

    func notifyDidChange<T>(event: ValueChange<T>) {

    }
}

public struct Observable<T>: AnyObservable {
    var subscribers = Subscribers()

    public var value: T {
        willSet { willSetValue(newValue, value) }
        didSet { didSetValue(value, oldValue) }
    }

    func willSetValue(newValue: T, _ oldValue: T) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        subscribers.notifyWillChange(change)
    }

    func didSetValue(newValue: T, _ oldValue: T) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        subscribers.notifyDidChange(change)
    }


    public func subscribe(subscriber: Any) {
        subscribers.append(subscriber)
    }

    public func unsubscribe(subscriber: Any) {
        subscribers.remove(subscriber)
    }


    public init(_ value: T) {
        self.value = value
    }
}

public func += <T: AnyObservable> (inout observable: T, subscriber: Any) {
    observable.subscribe(subscriber)
}

public func -= <T: AnyObservable> (inout observable: T, subscriber: Any) {
    observable.unsubscribe(subscriber)
}
