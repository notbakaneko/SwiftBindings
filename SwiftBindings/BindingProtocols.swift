//
//  BindingProtocols.swift
//  SwiftBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation

public protocol Bindable {
    func unbind()
}

protocol AnyBinding: Bindable {
    typealias SourceType
    typealias TargetType
}