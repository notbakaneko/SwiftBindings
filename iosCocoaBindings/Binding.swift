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


public struct ValueChangedEvent<T> {

}

public struct ValueChange<T> {
    public let oldValue: T
    public let newValue: T
}


public struct Observable<T> {
    public var value: T {
        willSet { willSetValue(newValue, value) }
        didSet { didSetValue(value, oldValue) }
    }

    func willSetValue(newValue: T, _ oldValue: T) {
        ValueChange(oldValue: oldValue, newValue: newValue)
    }

    func didSetValue(newValue: T, _ oldValue: T) {
        ValueChange(oldValue: oldValue, newValue: newValue)
    }

    public init(_ value: T) {
        self.value = value
    }
}


public class Binding<T>: NSObject {
    weak var target: NSObject?
    var source: Observable<T>

    public init(source: Observable<T>, target: NSObject, keyPath: String) {
        self.target = target
        self.source = source
        super.init()
        let options: NSKeyValueObservingOptions = NSKeyValueObservingOptions.New
        self.addObserver(self, forKeyPath: keyPath, options: options, context: bindingContext)



    }

    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        debugPrint("\(keyPath) changed: ")
        debugPrintln(change)
    }

    public func releaseBindings(target: NSObject) {
        target.removeObserver(self, forKeyPath: "string")
    }
}

var nnicb_bindingKey: Void?
extension NSObject: NSObjectProtocol {
    func nnicb_binding() -> AnyObject? {
        return objc_getAssociatedObject(self, &nnicb_bindingKey)
    }

    func nnicb_setBinding<T>(binding: Binding<T>?) {
        objc_setAssociatedObject(self, &nnicb_bindingKey, binding, UInt(bitPattern: OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

    func bind<T>(key: String, to: Observable<T>) {
        if let binding = nnicb_binding() as? Binding<T> {
            // remove binding
            binding.releaseBindings(self)
        }

        let binding = Binding<T>(source: to, target: self, keyPath: key)
//        binding.source = to
        nnicb_setBinding(binding)
    }

    func unbind(key: String) {

    }

    func releaseBindings<T>() {
        if let binding = nnicb_binding() as? Binding<T> {
            binding.releaseBindings(self)
        }
    }
}