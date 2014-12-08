//
//  Binding.swift
//  SwiftBindings
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
public class BasicBinding<T: Equatable, O1: MutableObservable, O2: MutableObservable where O1.ValueType == T, O2.ValueType == T>: AnyBinding {
    typealias SourceType = T
    typealias TargetType = T
    typealias SourceObservableType = O1
    typealias TargetObservableType = O2

    var source: O1
    var target: O2

    var ss: EventSubscription<ValueChange<T>>?
    var st: EventSubscription<ValueChange<T>>?

    public init(_ source: SourceObservableType, _ target: TargetObservableType) {
        self.source = source
        self.target = target
        self.target.value = self.source.value   // initialize target value to source value.

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

    public func unbind() {
        if let sub = ss {
            self.source -= sub
        }

        if let sub = st {
            self.target -= sub
        }
    }

    deinit {
        unbind()
    }
}


public class EquivalentClassBinding<T: Equatable, O: MutableObservable where O.ValueType == T> : BasicBinding<T, O, O> {
    override public init(_ source: O, _ target: O) {
        super.init(source, target)
    }
}

