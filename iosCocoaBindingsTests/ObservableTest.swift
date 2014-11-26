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
        a.string.value = "test"

        let afterSubscription = a.string.subscribe(.After) {
            XCTAssert($0.oldValue == "test")
            XCTAssert($0.newValue == "the quick brown fox jumped over the lazy dog")
            XCTAssert(a.string.value == $0.newValue)
        }

        let beforeSubscription = a.string.subscribe(.Before) {
            XCTAssert($0.oldValue == "test")
            XCTAssert($0.newValue == "the quick brown fox jumped over the lazy dog")
            XCTAssert(a.string.value == $0.oldValue)
        }

        a.string.value = "the quick brown fox jumped over the lazy dog"
    }

    func test_observableInt() {
        var int = Observable<Int>(5)

        let sub = int += {
            debugPrintln("changing \($0.oldValue) to \($0.newValue)")
            XCTAssert(int.value == 2)
        }

        int.value = 2
    }

    func test_whenAddingAndRemovingSubscription_afterValueChange() {
        let a = TestClass()

        XCTAssert(a.string.afterValueChange.observerCount == 0)
        let subscription = a.string.subscribe(.After) {
            debugPrintln("changing \($0.oldValue) to \($0.newValue)")
        }
        XCTAssert(a.string.afterValueChange.observerCount == 1)
        a.string.unsubscribe(subscription)
        XCTAssert(a.string.afterValueChange.observerCount == 0)
    }

    func test_whenAddingAndRemovingSubscription_beforeValueChange() {
        let a = TestClass()

        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        let subscription = a.string.subscribe(.Before) {
            debugPrintln("changing \($0.oldValue) to \($0.newValue)")
        }
        XCTAssert(a.string.beforeValueChange.observerCount == 1)
        a.string.unsubscribe(subscription)
        XCTAssert(a.string.beforeValueChange.observerCount == 0)

    }

    func test_whenAddingAndRemovingSubscriptionViaOperator() {
        let a = TestClass()

//        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)

        let subscription = a.string += {
            debugPrintln("changing \($0.oldValue) to \($0.newValue)")
        }

//        XCTAssert(a.string.beforeValueChange.observerCount == 1)
        XCTAssert(a.string.afterValueChange.observerCount == 1)

        a.string -= subscription

//        XCTAssert(a.string.beforeValueChange.observerCount == 0)
        XCTAssert(a.string.afterValueChange.observerCount == 0)
    }
}
