//
//  AnyObservable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation



public protocol AnyObservable {
    typealias ValueType

    var value: ValueType { get }

    func subscribe(type: ValueChangeType, observer: ValueChange<ValueType> -> ()) -> EventSubscription<ValueChange<ValueType>>
    func unsubscribe(subscription: EventSubscription<ValueChange<ValueType>>)
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
