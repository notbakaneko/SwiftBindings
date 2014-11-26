//
//  Binding.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 21/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation
import ObjectiveC

let bindingContext = UnsafeMutablePointer<()>()


/**
*  Swift-based basic 2-way binding.
*/
public class BasicBinding<T: Equatable, O: MutableObservable where O.ValueType == T>: AnyBinding {
    typealias SourceType = T
    typealias TargetType = T
    typealias ObservableType = O

    var source: ObservableType
    var target: ObservableType

    var ss: EventSubscription<ValueChange<T>>?
    var st: EventSubscription<ValueChange<T>>?

    public init(_ source: ObservableType, _ target: ObservableType) {
        self.source = source
        self.target = target

        self.ss = self.source.subscribe(.After, observer: sourceObserver)
        self.st = self.target.subscribe(.After, observer: targetObserver)
    }

    func sourceObserver(change: ValueChange<T>) {
        debugPrintln("changing \(change.oldValue) to \(change.newValue), source: \(source.value)")
        if target.value != change.newValue {
            target.value = change.newValue
        }
    }

    func targetObserver(change: ValueChange<T>) {
        debugPrintln("changing \(change.oldValue) to \(change.newValue), target: \(target.value)")
        if source.value != change.newValue {
            source.value = change.newValue
        }
    }

    func unbind() {
        if let sub = ss {
            self.source -= sub
        }

        if let sub = st {
            self.target -= sub
        }
    }
}
