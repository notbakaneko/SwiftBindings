//
//  EventSubscription.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 23/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation



public protocol AnyEventSubscription: Hashable {

}

public class EventSubscription: AnyEventSubscription {
    let id: Int
    init(_ id: Int) {
        self.id = id
    }

    public var hashValue: Int {
        return id.hashValue
    }
}

public func ==(lhs: EventSubscription, rhs: EventSubscription) -> Bool {
    return lhs === rhs
}