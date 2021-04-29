//
//  temochi_butasanUITests.swift
//  temochi-butasanUITests
//
//  Created by tilda on 2021/04/25.
//

import XCTest

class temochi_butasanUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameScene() throws {
        let app = XCUIApplication()
        let window = app.windows.element(boundBy: 0)
        app.launch()
        let buta = app.otherElements["buta"]
        
        // 画面上にブタが存在していること
        XCTAssert(window.frame.contains(buta.frame))
        
        // ブタをスワイプすることで、ブタの位置が変化すること
        let beforeSwipePosition = buta.frame.origin
        buta.swipeLeft()
        let afterSwipePosition = buta.frame.origin
        XCTAssertNotEqual(beforeSwipePosition.x, afterSwipePosition.x)
        
        // ブタをスワイプすることで、ブタの速度が変化し、移動し始めること
        buta.swipeUp(velocity: XCUIGestureVelocity.slow)
        sleep(1)
        let beforeMovePosition = buta.frame.origin
        sleep(1)
        let afterMovePosition = buta.frame.origin
        XCTAssertNotEqual(beforeMovePosition.y, afterMovePosition.y)
        
        //　ブタをたくさんスワイプしても画面の外にはみ出さないこと
        for _ in 1...8 {
            buta.swipeDown(velocity: XCUIGestureVelocity.slow)
            sleep(1)
        }
        XCTAssert(window.frame.contains(buta.frame))
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
