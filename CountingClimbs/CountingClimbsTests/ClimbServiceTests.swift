//
//  ClimbServiceTests.swift
//  CountingClimbsTests
//
//  Created by Sophia Chiang on 4/20/23.
//

import XCTest
@testable import CountingClimbs

final class ClimbServiceTests: XCTestCase {
    var systemUnderTest: ClimbService!
    
    override func setUpWithError() throws {
        self.systemUnderTest = ClimbService()

    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil

    }

    func testAPI_returnsSuccessfulResult() {
        var climbs: [Climb]!
        var error : Error?
        
        let promise = expectation(description: "Completion handler is invoked")
        
        self.systemUnderTest.getClimbs(completion: { data, shouldntHappen in
            climbs = data
            error = shouldntHappen
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(climbs)
        XCTAssertNil(error)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
