//
//  ankka_newUITests.swift
//  ankka_newUITests
//
//  Created by Matti Saarela on 24/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import XCTest
@testable import ankka_new

class ankka_newUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAnkkaPost() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Add Sightning"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["Mallard"].press(forDuration: 0.8);/*[[".pickers.pickerWheels[\"Mallard\"]",".tap()",".press(forDuration: 0.8);",".pickerWheels[\"Mallard\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        let element2 = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let element = element2.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("400")
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.tap()
        textField2.typeText("Testiankka")
        element2.buttons["Add Sightning"].tap()
        app.alerts["Successful"].buttons["OK"].tap()
 
        
    }
    
}
