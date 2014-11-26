//
//  ValueChangeType.swift
//  SwiftBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import Foundation


public protocol AnyValueChangeType {
}

public enum ValueChangeType: AnyValueChangeType {
    case Before
    case After
}
