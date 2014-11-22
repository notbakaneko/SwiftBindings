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

    var value: ValueType { get }

    func subscribe(observer: ValueChange<ValueType> -> ()) -> EventSubscription
    func unsubscribe(subscription: EventSubscription)
}



class Subscribers<T> {
    typealias EventHandler = ValueChange<T> -> ()
    private var observers = [EventSubscription: EventHandler]()

    init() {}

    func append(subscriber: EventHandler) -> EventSubscription {
        let subscription = EventSubscription(observers.count)
        observers[subscription] = subscriber
        return subscription
    }

    func remove(subscription: EventSubscription) {
        observers[subscription] = nil
    }

    func notify(event: ValueChange<T>) {
        for o in observers.values.array {
            o(event)
        }
    }
}


public struct Observable<T>: AnyObservable {
    typealias ValueType = T
    typealias EventHandler = ValueChange<ValueType> -> ()

    var beforeValueChange = Subscribers<T>()
    var afterValueChange = Subscribers<T>()


    public var value: T {
        willSet { willSetValue(newValue, value) }
        didSet { didSetValue(value, oldValue) }
    }

    func willSetValue(newValue: T, _ oldValue: T) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        beforeValueChange.notify(change)
    }

    func didSetValue(newValue: T, _ oldValue: T) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        afterValueChange.notify(change)
    }


    public func subscribe(observer: EventHandler) -> EventSubscription {
        beforeValueChange.append(observer)
        return afterValueChange.append(observer)
    }

    public func unsubscribe(subscription: EventSubscription) {
        beforeValueChange.remove(subscription)
        afterValueChange.remove(subscription)
    }


    public init(_ value: T) {
        self.value = value
    }
}

public func += <T: AnyObservable> (inout observable: T, observer: ValueChange<T.ValueType> -> ()) -> EventSubscription {
    return observable.subscribe(observer)
}

public func -= <T: AnyObservable> (inout observable: T, subscription: EventSubscription) {
    observable.unsubscribe(subscription)
}
