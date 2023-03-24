//
//  ClimbListViewControllerTests.swift
//  CountingClimbsTests
//
//  Created by Sophia Chiang on 4/20/23.
//

import XCTest
@testable import CountingClimbs

final class ClimbListViewControllerTests: XCTestCase {
    var systemUnderTest: ClimbListViewController!

    override func setUpWithError() throws {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as!
            UINavigationController
        self.systemUnderTest = navigationController.topViewController as?
            ClimbListViewController
        
        UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first!
            .rootViewController = self.systemUnderTest
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(self.systemUnderTest.view)

    }

    func testTableView_loadsClimbs() {
        let mockClimbService = MockClimbService()
        let mockClimbs = [
            Climb(named: "Yellow Slab", grade: "v4", type: "bouldering", imageUrl: "https://res.cloudinary.com/sagacity/image/upload/c_crop,h_3333,w_5000,x_0,y_0/c_limit,dpr_auto,f_auto,fl_lossy,q_80,w_1080/220422_tmg_half_moon_bouldering_010_psdyhp.jpg"),
            Climb(named: "Yellow Slab", grade: "v4", type: "bouldering", imageUrl: "https://res.cloudinary.com/sagacity/image/upload/c_crop,h_3333,w_5000,x_0,y_0/c_limit,dpr_auto,f_auto,fl_lossy,q_80,w_1080/220422_tmg_half_moon_bouldering_010_psdyhp.jpg"),
            Climb(named: "Yellow Slab", grade: "v4", type: "bouldering", imageUrl: "https://res.cloudinary.com/sagacity/image/upload/c_crop,h_3333,w_5000,x_0,y_0/c_limit,dpr_auto,f_auto,fl_lossy,q_80,w_1080/220422_tmg_half_moon_bouldering_010_psdyhp.jpg")]
        
        mockClimbService.mockClimbs = mockClimbs
        
        self.systemUnderTest.viewDidLoad()
        self.systemUnderTest.climbService = mockClimbService
        
        XCTAssertEqual(0, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        self.systemUnderTest.viewWillAppear(false)
        
        XCTAssertEqual(mockClimbs.count, self.systemUnderTest.climbs.count)
        XCTAssertEqual(mockClimbs.count, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        
    }
    
    class MockClimbService: ClimbService {
        var mockClimbs: [Climb]?
        var mockError: Error?
        
        override func getClimbs(completion: @escaping ([Climb]?, Error?) -> ()) {
            completion(mockClimbs, mockError)
        }
    }

}
