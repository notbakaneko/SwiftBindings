//
//  EventSubscription.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 23/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation



public protocol AnyEventSubscription {
    
}

public class EventSubscription<T: AnyValueChange>: AnyEventSubscription {
    typealias EventHandler = T -> ()

    let handler: EventHandler
    init(_ handler: EventHandler) {
        self.handler = handler
    }

}
