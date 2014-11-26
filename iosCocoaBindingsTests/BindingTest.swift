//
//  BindingTest.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 25/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//


import XCTest


class BindingTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_binding() {
        var source = Observable<Int>(1)
        var target = Observable<Int>(-1)
        let binding = BasicBinding<Int>(source, target)

        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.value)
        XCTAssert(source.value != target.value)

        source.value = 5

        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.value)
        XCTAssert(source.value == target.value)
    }

    func test_unbinding() {
        var source = Observable<Int>(1)
        var target = Observable<Int>(-1)
        let binding = BasicBinding<Int>(source, target)

        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.value)
        XCTAssert(source.value != target.value)

        binding.unbind()
        source.value = 5

        XCTAssertNotNil(source.value)
        XCTAssertNotNil(target.value)
        XCTAssert(source.value != target.value)
    }
}
