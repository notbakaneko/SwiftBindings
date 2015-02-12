//
//  SwiftBindingsTests.swift
//  SwiftBindingsTests
//
//  Created by bakaneko on 21/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import XCTest


class SwiftBindingsTests: XCTestCase {
    class TargetObject: NSObject {
        dynamic var string: NSString = "not an empty string"
        dynamic var int: NSInteger = 0
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_kvoObservable() {
        let source = TargetObject()
        let observableSource = KVOObservable<String>(source, "string")

        observableSource.subscribe(.After) {
            debugPrintln("changing \($0.oldValue) to \($0.newValue)")
            XCTAssert($0.oldValue == "not an empty string")
            XCTAssert($0.newValue == "the quick brown fox jumped over the lazy dog")
            XCTAssert(source.string == $0.newValue)
        }

        source.string = "the quick brown fox jumped over the lazy dog"
        observableSource.unobserve()
    }

    func test_nsobjectBinding() {
        let source = TargetObject()
        source.string = "a string"
        let observableSource = KVOObservable<String>(source, "string")
        let target = TargetObject()
        target.string = "a different string"
        let observableTarget = KVOObservable<String>(target, "string")

        let binding = BasicBinding(observableSource, observableTarget)


        XCTAssertNotNil(source.string)
        XCTAssertNotNil(target.string)
        XCTAssert(source.string.isEqualToString(target.string as! String))

        source.string = "asd"

        XCTAssertNotNil(source.string)
        XCTAssertNotNil(target.string)
        XCTAssert(source.string.isEqualToString(target.string as! String))
        XCTAssert(target.string.isEqualToString("asd"))

        observableSource.unobserve()
    }
}
