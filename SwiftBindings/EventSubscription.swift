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
}

// TODO: implicitly hold a weak reference to the subscriber so we can auto unsubscribe when out of scope?
public class EventSubscription<T: AnyValueChange>: AnyEventSubscription {
    typealias EventHandler = T -> ()

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