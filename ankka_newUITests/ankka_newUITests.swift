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
        app.tabBars.buttons["Lisää havainto"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let textField = scrollViewsQuery.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText("20")
        
        let textField2 = scrollViewsQuery.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField2.tap()
        textField2.typeText("100")
        
        let textField3 = scrollViewsQuery.children(matching: .textField).element(boundBy: 2)
        textField3.tap()
        textField3.tap()
        textField3.typeText("Perusankka")
        app/*@START_MENU_TOKEN@*/.scrollViews.containing(.staticText, identifier:"Add sightning").element/*[[".scrollViews.containing(.button, identifier:\"Add Sightning\").element",".scrollViews.containing(.staticText, identifier:\"Species\").element",".scrollViews.containing(.staticText, identifier:\"Description\").element",".scrollViews.containing(.staticText, identifier:\"Count\").element",".scrollViews.containing(.staticText, identifier:\"Sightning ID\").element",".scrollViews.containing(.staticText, identifier:\"Add sightning\").element"],[[[-1,5],[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app/*@START_MENU_TOKEN@*/.buttons["Add Sightning"]/*[[".scrollViews.buttons[\"Add Sightning\"]",".buttons[\"Add Sightning\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        

    }
    
}
