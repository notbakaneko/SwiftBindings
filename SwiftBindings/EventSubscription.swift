//
//  EventSubscription.swift
//  SwiftBindings
//
//  Created by bakaneko on 23/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public protocol AnyEventSubscription : Equatable {
    typealias EventHandler
    typealias ValueChange
}

// TODO: implicitly hold a weak reference to the subscriber so we can auto unsubscribe when out of scope?
public class EventSubscription<T>: AnyEventSubscription {
    typealias EventHandler = T -> ()
    typealias ValueChange = T

    let type: ValueChangeType
    let handler: EventHandler

    init(_ type: ValueChangeType, _ handler: EventHandler) {
        self.handler = handler
        self.type = type
    }
}

public func ==<T>(lhs: EventSubscription<T>, rhs: EventSubscription<T>) -> Bool {
    return lhs === rhs
}