//
//  Observable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public protocol AnyValueChange {
    typealias ValueType
}

public struct ValueChange<T> : AnyValueChange {
    typealias ValueType = T
    public let oldValue: ValueType
    public let newValue: ValueType
}

//public struct ValueChangeEvent<T: AnyValueChange> {
//    typealias ValueType = T
//    typealias EventHandler = (AnyValueChange) -> ()
//}

public protocol AnyObservable {
    typealias ValueType

    var value: ValueType { get }

    func subscribe(observer: ValueChange<ValueType> -> ()) -> EventSubscription<ValueChange<ValueType>>
    func unsubscribe(subscription: EventSubscription<ValueChange<ValueType>>)
}



class Subscribers<T> {
    typealias EventHandler = ValueChange<T> -> ()
//    typealias EventHandler = AnyValueChange -> ()
    private var observers = [EventSubscription<ValueChange<T>>]()

    init() {}

    func append(subscriber: EventHandler) -> EventSubscription<ValueChange<T>> {
        let subscription = EventSubscription(subscriber)
        observers.append(subscription)
        return subscription
    }

    func remove(subscription: EventSubscription<ValueChange<T>>) {

    }

    func notify(event: ValueChange<T>) {
        for o in observers {
            o.handler(event)
        }
    }
}


public struct Observable<T>: AnyObservable {
    public typealias ValueType = T
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


    public func subscribe(observer: ValueChange<T> -> ()) -> EventSubscription<ValueChange<T>> {
        beforeValueChange.append(observer)
        return afterValueChange.append(observer)
    }

    public func unsubscribe(subscription: EventSubscription<ValueChange<T>>) {
        beforeValueChange.remove(subscription)
        afterValueChange.remove(subscription)
    }


    public init(_ value: T) {
        self.value = value
    }
}

public func += <T: AnyObservable>(inout observable: T, observer: ValueChange<T.ValueType> -> ()) -> EventSubscription<ValueChange<T.ValueType>> {
    return observable.subscribe(observer)
}

public func -= <T: AnyObservable>(inout observable: T, subscription: EventSubscription<ValueChange<T.ValueType>>) {
    observable.unsubscribe(subscription)
}
