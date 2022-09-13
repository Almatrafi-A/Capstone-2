//
//  Capstone2Tests.swift
//  Capstone2Tests
//
//  Created by Maan Abdullah on 09/09/2022.
//

import XCTest
@testable import Capstone2

class Capstone2Tests: XCTestCase {

    var systemUnitTest: ViewController!
    
    
    func testCheck_Sdk_Key(){
        let key = ViewController.instance.sdkKEY
        XCTAssert(key != nil && !(key?.isEmpty ?? true))
    }
    
    override func setUpWithError() throws {
        systemUnitTest = ViewController()
    }

    override func tearDownWithError() throws {
        systemUnitTest = nil
     }
    

      func testCodeIsFastEnough() {
        self.measure() {
          // performance-sensitive code here
        
        }
      }

    
    
//    func testFetchImages() {
//        //api is syncrosiz operatioin
//       let expectation = XCTestExpectation(description: "Location API")
//        var responseErroor = Error?.self
//        var responseFetch  = [ImagesFetched]?.self
//
//        sut.fetchImages {  (imagesFetched , error) in
////            responseErroor = error
////            responseFetch  = imagesFetched
//            expectation.fulfill()              //marks the expectation as have been met
//        }
//        wait(for: [expectation], timeout: 5)
//
//        XCTAssertNil(responseErroor)          //make sure the error = nil
//        XCTAssertNotNil(responseFetch)        //mare sure my response != nil
//     }
    
/*
 sut.fetchImages {  (imagesFetched , _: Error?) in
     responseErroor = Error?.self
     responseFetch  = [ImagesFetched]?.self
 */

}
