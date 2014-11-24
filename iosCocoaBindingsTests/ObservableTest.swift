//
//  ObservableTest.swift
//  iosCocoaBindings
//
//  Created by bakaneko on 22/11/2014.
//  Copyright (c) 2014 nekonyan. All rights reserved.
//

import XCTest

class Observer<T> {
    var value = Optional<T>()

    func observe(v: ValueChange<T>) -> () {
        debugPrintln("value changed from \(v.oldValue) to \(v.newValue)")
        value = v.newValue
    }
}

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
        let observer = Observer<String>()

        let subscription = a.string.subscribe(observer.observe)

        a.string.value = "the quick brown fox jumped over the lazy dog"
        XCTAssert(observer.value == "the quick brown fox jumped over the lazy dog")
    }
}
