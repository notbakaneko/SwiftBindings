//
//  KVOObservable.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 26/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


private var proxyContext = 0
public class KVOObservable<T>: MutableObservable, KVOProxyType {
    typealias ValueType = T
    var beforeValueChange = Subscribers<ValueType>(.Before)
    var afterValueChange = Subscribers<ValueType>(.After)

    private var kvoHandler: KVOHandler?
    private var object: AnyObject
    private var keyPath: String

    public var transform: AnyObject -> T = {
        return $0 as T
    }

    public var value: ValueType {
        get {
            return object.valueForKey(keyPath) as T
        }
        set {
            object.setValue(newValue as NSObject, forKey: keyPath)
        }
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

    public init(_ object: NSObject, _ keyPath: String) {
        self.object = object
        self.keyPath = keyPath

        self.kvoHandler = KVOHandler(self)
        self.object.addObserver(kvoHandler!, forKeyPath: self.keyPath, options: NSKeyValueObservingOptions.Old | NSKeyValueObservingOptions.New, context: &proxyContext)
    }

    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        let oldValue: AnyObject = change[NSKeyValueChangeOldKey]!
        let newValue: AnyObject = change[NSKeyValueChangeNewKey]!
        didSetValue(transform(newValue), transform(oldValue))
    }

    public func unobserve() {
        self.object.removeObserver(kvoHandler!, forKeyPath: self.keyPath)
        kvoHandler = nil
    }
}



/**
*  This class acts as a non-generic receiver for KVO notifications.
*  It seems that trying to send KVO notifications to a generic type results in NSInternalInconsistencyException
*  An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
*/
@objc class KVOHandler: NSObject {
    var proxy: KVOProxyType

    init(_ proxy: KVOProxyType) {
        self.proxy = proxy
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        proxy.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    }
}
