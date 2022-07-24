//
//  SRSnappAssignmentTests.swift
//  SRSnappAssignmentTests
//
//  Created by Siamak Rostami on 5/20/22.
//

import XCTest
@testable import SRSnappAssignment

class TwitterStreamTests: XCTestCase {
    
    var networkInstance : TwitterNetworkRepository?
    
    override func setUpWithError() throws {
        self.networkInstance = TwitterNetworkRepository()
        debugPrint("Object Initialized")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        self.networkInstance = nil
        debugPrint("Object Deinitialized")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //Test get rule from twitter api
    func testApiCall() throws{
        let expect = expectation(description: "fetch rule")
        self.networkInstance?.getRule(completion: { ruleData in
            switch ruleData{
            case .success(let rule):
                guard let rule = rule else {return}
                XCTAssertNotNil(rule)
            case .failure(let error):
                XCTAssertThrowsError(error)
            }
            expect.fulfill()
        })
        wait(for: [expect], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
           try? testApiCall()
            // Put the code you want to measure the time of here.
        }
    }
    
}
