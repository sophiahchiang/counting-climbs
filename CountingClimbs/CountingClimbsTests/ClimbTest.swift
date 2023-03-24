//
//  ClimbTest.swift
//  CountingClimbsTests
//
//  Created by Sophia Chiang on 4/20/23.
//

import XCTest
@testable import CountingClimbs

final class ClimbTest: XCTestCase {

    func testClimbDebugDescription() {
        let subjectUnderTest = Climb(
            named: "Best Climb",
            grade: "v8",
            type: "Outdoor bouldering",
            imageUrl: "https://www.kendallcliffs.com/wp-content/uploads/2016/10/man-bouldering-on-large-boulder.jpg"
        )
        
        let actualValue = subjectUnderTest.debugDescription
        
        let expectedValue = "Climb(name: Best Climb, grade: v8, type: Outdoor bouldering)"
        XCTAssertEqual(actualValue, expectedValue)
        
    }

}
