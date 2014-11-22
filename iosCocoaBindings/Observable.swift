//
//  Observable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public protocol AnyValueChange {
}

public struct ValueChange<T> : AnyValueChange {
    public let oldValue: T
    public let newValue: T
}

public struct ValueChangeEvent<T: AnyValueChange> {
    typealias EventHandler = (AnyValueChange) -> ()
}

public protocol AnyObservable {
    typealias ValueType

    func subscribe(observer: ValueChange<ValueType> -> ())
    func unsubscribe(observer: ValueChange<ValueType> -> ())
}



class Subscribers<T> {
    typealias EventHandler = ValueChange<T> -> ()
    private var observers = [EventHandler]()

    init() {}

    func append(subscriber: EventHandler) {
        observers.append(subscriber)
    }

    func remove(subscriber: EventHandler) {

    }

    func notifyWillChange<T>(event: ValueChange<T>) {

    }

    func notifyDidChange<T>(event: ValueChange<T>) {
    }
}


public struct Observable<T>: AnyObservable {
    typealias EventHandler = ValueChange<T> -> ()
    var subscribers = Subscribers<T>()

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


    public func subscribe(observer: EventHandler) {
        subscribers.append(observer)
    }

    public func unsubscribe(observer: EventHandler) {
        subscribers.remove(observer)
    }


    public init(_ value: T) {
        self.value = value
    }
}

public func += <T: AnyObservable> (inout observable: T, observer: ValueChange<T.ValueType> -> ()) {
    observable.subscribe(observer)
}

public func -= <T: AnyObservable> (inout observable: T, observer: ValueChange<T.ValueType> -> ()) {
    observable.unsubscribe(observer)
}
