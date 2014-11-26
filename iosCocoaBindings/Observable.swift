//
//  Observable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation



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


public class Observable<T>: AnyObservable {
    public typealias ValueType = T?
    var beforeValueChange = Subscribers<ValueType>(.Before)
    var afterValueChange = Subscribers<ValueType>(.After)

    public var value: ValueType {
        willSet { willSetValue(newValue, value) }
        didSet { didSetValue(value, oldValue) }
    }

    func willSetValue(newValue: ValueType, _ oldValue: ValueType) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        beforeValueChange.notify(change)
    }

    func didSetValue(newValue: ValueType, _ oldValue: ValueType) {
        let change = ValueChange(oldValue: oldValue, newValue: newValue)
        afterValueChange.notify(change)
    }

    public func subscribe(type: ValueChangeType, observer: ValueChange<ValueType> -> ()) -> EventSubscription<ValueChange<ValueType>> {
        switch type {
        case .Before:
            return beforeValueChange.append(observer)
        case .After:
            return afterValueChange.append(observer)
        }
    }

    public func unsubscribe(subscription: EventSubscription<ValueChange<ValueType>>) {
        switch subscription.type {
        case .Before:
            beforeValueChange.remove(subscription)
        case .After:
            afterValueChange.remove(subscription)
        }
    }

    public init(_ value: ValueType) {
        self.value = value
    }
}

