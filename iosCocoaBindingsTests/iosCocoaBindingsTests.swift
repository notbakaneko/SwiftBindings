//
//  iosCocoaBindingsTests.swift
//  iosCocoaBindingsTests
//
//  Created by bakaneko on 21/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import UIKit
import XCTest

@objc
class TargetObject: NSObject {
    dynamic var string: NSString?
    var int: NSInteger?
}

class SourceObject {
    var string: Observable<String?> = Observable<String?>(nil)
}


class iosCocoaBindingsTests: XCTestCase {

    var target: TargetObject?
    var source: SourceObject?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testSourceChangePropagates() {
        let target = TargetObject()
        let source = SourceObject()

        target.bind("string", to: source.string)

        source.string.value = "String Value"
        XCTAssert(source.string.value == target.string, "expect source.string to be == target.string")

        target.releaseBindings()
    }

    func testTargetChangePropagates() {
        let target = TargetObject()
        let source = SourceObject()
        target.bind("string", to: source.string)


        target.string = "String Value"
        XCTAssert(source.string.value == target.string, "expect source.string to be == target.string")

        target.releaseBindings()
    }
}
