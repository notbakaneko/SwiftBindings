//
//  MixedBindingsTest.swift
//  SwiftBindings
//
//  Created by bakaneko on 4/12/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import XCTest

class MixedBindingsTest: XCTestCase {
    class TestObject: NSObject {
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

    func test_kvoSource() {
        let source = TestObject()
        source.string = "the quick brown fox jumped over the lazy dog"
        let observableSource = KVOObservable<String>(source, "string")

        let target = Observable("I'm a little tea pot")


        let binding = BasicBinding(observableSource, target)


        XCTAssertNotNil(source.string)
        XCTAssertNotNil(target.value)
        XCTAssert(!source.string.isEqualToString(target.value))

        source.string = "asd"

        XCTAssertNotNil(source.string)
        XCTAssertNotNil(target.value)
        XCTAssert(source.string.isEqualToString(target.value))
        XCTAssert(target.value == "asd")

        binding.unbind()
    }

    func test_swiftSource() {
        let source = Observable("I'm a little tea pot")

        let target = TestObject()
        target.string = "the quick brown fox jumped over the lazy dog"
        let observableTarget = KVOObservable<String>(target, "string")


        let binding = BasicBinding(source, observableTarget)


        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.string)
        XCTAssert(source.value != target.string)

        source.value = "asd"

        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.string)
        XCTAssert(source.value == target.string)
        XCTAssert(target.string == "asd")

        binding.unbind()
    }
}
