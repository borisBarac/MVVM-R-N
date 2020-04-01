//
//  RouterTests.swift
//  Music searchTests
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
import AVKit

@testable import Homework

class RouterTests: XCTestCase {

    var router: Router!
    let detailItemId = 33

    override func setUp() {
        router = Router()
    }

    override func tearDown() {
    }

    func testMainRoute() {
        guard let route = try? router.calculate(route: Route(routePath: .main)) else {
            XCTFail("ROUTE IS NIL")
            return
        }
        let pass = route.embedInNavBar == true && route.hasNavigation == false && route.routePath == .main && route.presentationStyle == .root
        XCTAssert(pass)
    }

    func testMakeView() {
        let main = try? router.makeView(route: Route(routePath: .main), data: nil)
        let detail = try? router.makeView(route: Route(routePath: .detail), data: detailItemId)
        let detailError = try? router.makeView(route: Route(routePath: .detail), data: nil)

        XCTAssertNotNil(main)
        XCTAssertNotNil(detail)
        XCTAssertNil(detailError)
    }

    func testShowRoot() {
        let route = Route(routePath: .main)
        XCTAssertNotNil(try router.showRoute(route: route, data: nil))
        let vc = router.topViewController
        let hasNav = vc?.navigationController
        let classIsOK = vc is MainViewController

        XCTAssertNotNil(hasNav)
        XCTAssertNotNil(classIsOK)
    }

    func testShowDetail() {
        let mainExpectation = expectation(description: "Detail show")

        let route = Route(routePath: .detail)

        // data - just po pass nill checks
        XCTAssertNotNil(try router.showRoute(route: route, data: 22, completion: { VC in
            mainExpectation.fulfill()
        }))

        waitForExpectations(timeout: 5) { error in
            let hasNav = self.router.topViewController?.navigationController
            let classIsOK = self.router.topViewController as? DetailViewController

            XCTAssertNotNil(hasNav)
            XCTAssertNotNil(classIsOK)
        }
    }

    func testShowPlayer() {
        let mainExpectation = expectation(description: "Player show")
        let route = Route(routePath: .player)
        let videoUrl = URL(string: "https://prod-stpeter-pmd.akamai.cdn.rakuten.tv/c/b/f/cbfe8f488f44a1b76e8e_SS_16_9_432p_1100_MP30_PAR1_ch/cbfe8f488f44a1b76e8e_SS_16_9_432p_1100_MP30_PAR1_ch.mp4?token=st=1584964161~exp=1584985761~acl=*/c/b/f/cbfe8f488f44a1b76e8e_SS_16_9_432p_1100_MP30_PAR1_ch/cbfe8f488f44a1b76e8e_SS_16_9_432p_1100_MP30_PAR1_ch.mp4*~hmac=9417780eaba4fd27c161ba6d454e6c3aad433bad6729c474a692fe41a54f6a7a")!

        // data - just po pass nill checks
        XCTAssertNotNil(try router.showRoute(route: route, data: videoUrl, completion: { VC in
            mainExpectation.fulfill()
        }))

        waitForExpectations(timeout: 5) { error in
            let hasNav = self.router.topViewController?.navigationController
            let classIsOK = self.router.topViewController as? AVPlayerViewController

            XCTAssertNil(hasNav)
            XCTAssertNotNil(classIsOK)
        }
    }

}
