//
//  ObservableTest.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import XCTest

class ObservableTest: XCTestCase {
    class TestClass {
        var string = Observable<String>("")
    }


    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_observable() {
        let a = TestClass()
        let subscription = a.string.subscribe {
            XCTAssert($0.newValue == "the quick brown fox jumped over the lazy dog")
        }

        a.string.value = "the quick brown fox jumped over the lazy dog"

    }

    func test_whenAddingAndRemovingSubscription() {
        let a = TestClass()

        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)
        let subscription = a.string.subscribe {
            debugPrintln($0.newValue)
        }

        XCTAssert(a.string.beforeValueChange.observerCount == 1)
        XCTAssert(a.string.afterValueChange.observerCount == 1)

        a.string.unsubscribe(subscription)

        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)
    }

    func test_whenAddingAndRemovingSubscriptionViaOperator() {
        let a = TestClass()

        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)

        let subscription = a.string += {
            debugPrintln($0.newValue)
        }

        XCTAssert(a.string.beforeValueChange.observerCount == 1)
        XCTAssert(a.string.afterValueChange.observerCount == 1)

        a.string -= subscription

        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)
    }
}
