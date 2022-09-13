//
//  MapAPITests.swift
//  MapAPITests
//
//  Created by Faisal Almutairi on 13/02/1444 AH.
//

import XCTest
@testable import MapAPI

class MapAPITests: XCTestCase {
    
    var sut : ViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = ViewController()
    }

    func testingTheDataSource(){
        XCTAssertNotNil(sut)
    }
    
    func testingTheLocationManeger(){
        XCTAssertNil(sut.locationManager.delegate)
    }

}
