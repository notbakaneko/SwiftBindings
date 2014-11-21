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



public class Binding: NSObject {
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

    func nnicb_setBinding(binding: Binding?) {
        objc_setAssociatedObject(self, &nnicb_bindingKey, binding, UInt(bitPattern: OBJC_ASSOCIATION_RETAIN_NONATOMIC))
    }

    func bind<T>(key: String, to: Observable<T>) {
        if let binding = nnicb_binding() as? Binding {
            // remove binding
            binding.releaseBindings(self)
        }

        let binding = Binding(source: to, target: self, keyPath: key)
//        binding.source = to
        nnicb_setBinding(binding)
    }

    func unbind(key: String) {

    }

    func releaseBindings() {
        if let binding = nnicb_binding() as? Binding {
            binding.releaseBindings(self)
        }
    }
}