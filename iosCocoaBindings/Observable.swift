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


public protocol AnyObservable {
    typealias ValueType

    var value: ValueType { get }

    func subscribe(type: ValueChangeType, observer: ValueChange<ValueType> -> ()) -> EventSubscription<ValueChange<ValueType>>
    func unsubscribe(subscription: EventSubscription<ValueChange<ValueType>>)
}



class Subscribers<T> {
    typealias EventHandler = ValueChange<T> -> ()
    private let type: ValueChangeType
    private var observers = [EventSubscription<ValueChange<T>>]()

    // exposed for testing.
    internal var observerCount: Int { return observers.count }

    init(_ type: ValueChangeType) {
        self.type = type
    }

    func append(subscriber: EventHandler) -> EventSubscription<ValueChange<T>> {
        let subscription = EventSubscription(type, subscriber)
        observers.append(subscription)
        return subscription
    }

    func remove(subscription: EventSubscription<ValueChange<T>>) {
        var array = observers
        for (i, e) in enumerate(array) {
            if subscription == array[i] {
                array.removeAtIndex(i)
                break
            }
        }

        observers = array
    }

    func notify(event: ValueChange<T>) {
        for o in observers {
            o.handler(event)
        }
    }
}


public struct Observable<T>: AnyObservable {
    public typealias ValueType = T
    var beforeValueChange = Subscribers<T>(.Before)
    var afterValueChange = Subscribers<T>(.After)


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


    public func subscribe(type: ValueChangeType, observer: ValueChange<T> -> ()) -> EventSubscription<ValueChange<T>> {
        switch type {
        case .Before:
            return beforeValueChange.append(observer)
        case .After:
            return afterValueChange.append(observer)
        }
    }

    public func unsubscribe(subscription: EventSubscription<ValueChange<T>>) {
        switch subscription.type {
        case .Before:
            beforeValueChange.remove(subscription)
        case .After:
            afterValueChange.remove(subscription)
        }
    }


    public init(_ value: T) {
        self.value = value
    }
}

/**
Convenience operator to subscribe to the after change event.
o += { change in
}

:param: observable The object to observe.
:param: observer   The observer function that will respond to the change event.

:returns: An object of the event subscription.
*/
public func += <T: AnyObservable>(inout observable: T, observer: ValueChange<T.ValueType> -> ()) -> EventSubscription<ValueChange<T.ValueType>> {
    return observable.subscribe(.After, observer)
}

/**
Convenience operator to unsubscribe from a change event.
o -= subscription

:param: observable   The object to stop observing.
:param: subscription The subscription object that was created from observing observable.
*/
public func -= <T: AnyObservable>(inout observable: T, subscription: EventSubscription<ValueChange<T.ValueType>>) {
    observable.unsubscribe(subscription)
}
