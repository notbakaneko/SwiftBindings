//
//  KVOProxyType.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 26/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


protocol KVOProxyType {
    func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>)
}