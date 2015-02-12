//
//  AnyObservable.swift
//  SwiftBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation



public protocol AnyObservable {
    typealias ValueType
    typealias ObservedValueChange

    var value: ValueType? { get }

    func subscribe(type: ValueChangeType, _ observer: ObservedValueChange -> ()) -> EventSubscription<ObservedValueChange>
    func unsubscribe(subscription: EventSubscription<ObservedValueChange>)
}


public protocol MutableObservable: AnyObservable {
    var value: ValueType? { get set }
}


/**
Convenience operator to subscribe to the after change event.
o += { change in
}

:param: observable The object to observe.
:param: observer   The observer function that will respond to the change event.

:returns: An object of the event subscription.
*/
public func += <T: AnyObservable, V where V == T.ObservedValueChange>(inout observable: T, observer: V -> ()) -> EventSubscription<V> {
    return observable.subscribe(ValueChangeType.After, observer)
}

/**
Convenience operator to unsubscribe from a change event.
o -= subscription

:param: observable   The object to stop observing.
:param: subscription The subscription object that was created from observing observable.
*/
public func -= <T: AnyObservable, V where V == T.ObservedValueChange>(inout observable: T, subscription: EventSubscription<V>) {
    observable.unsubscribe(subscription)
}


infix operator <- { associativity none assignment }
/**
Convenience operator to assign a value to an observable object.

:param: observable The mutable observable object to assign a value to.
:param: value      The value to assign.
*/
public func <- <O: MutableObservable, T where O.ValueType == T>(inout observable: O, value: T?) {
    observable.value = value
}

/**
Convenience operator to assign a value from an observable object.

:param: value      The value to assign to.
:param: observable The observable object to assign the value from.
*/
public func <- <O: AnyObservable, T where O.ValueType == T>(inout value: T?, observable: O) {
    value = observable.value
}