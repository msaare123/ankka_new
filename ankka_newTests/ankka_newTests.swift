//
//  ankka_newTests.swift
//  ankka_newTests
//
//  Created by Matti Saarela on 24/01/2018.
//  Copyright © 2018 Matti Saarela. All rights reserved.
//

import XCTest
@testable import ankka_new

class ankka_newTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecimalsOnly() {
        let testString = "123ldsjgf2348ldkgrjlsdkjg"
        let testString2 = "ödsoijgfoijsdf"
        let testString3 = "-123-123-"
        let testString4 = ""
        XCTAssertEqual(testString.decimalsOnly(), "1232348")
        XCTAssertEqual(testString2.decimalsOnly(), "")
        XCTAssertEqual(testString3.decimalsOnly(), "123123")
        XCTAssertEqual(testString4.decimalsOnly(), "")
    }
    
    
    
    
}
