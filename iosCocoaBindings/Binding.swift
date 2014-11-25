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
public class BasicBinding<T: Equatable>: AnyBinding {
    typealias SourceType = T
    typealias TargetType = T

    typealias ObservableType = Observable<T>


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


public class CocoaBinding: NSObject {
    weak var target: NSObject?
//    var source: Observable<T>

    public init<T>(source: Observable<T>, target: NSObject, keyPath: String) {
        self.target = target
//        self.source = source
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

    func nnicb_setBinding(binding: CocoaBinding?) {
        objc_setAssociatedObject(self, &nnicb_bindingKey, binding, UInt(bitPattern: OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

    func bind<T>(key: String, to: Observable<T>) {
        if let binding = nnicb_binding() as? CocoaBinding {
            // remove binding
            binding.releaseBindings(self)
        }

        let binding = CocoaBinding(source: to, target: self, keyPath: key)
//        binding.source = to
        nnicb_setBinding(binding)
    }

    func unbind(key: String) {

    }

    func releaseBindings() {
        if let binding = nnicb_binding() as? CocoaBinding {
            binding.releaseBindings(self)
        }
    }
}