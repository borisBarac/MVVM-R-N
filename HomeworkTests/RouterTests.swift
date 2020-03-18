//
//  RouterTests.swift
//  Music searchTests
//
//  Created by Boris Barac on 29/02/2020.
//  Copyright © 2020 Boris Barac. All rights reserved.
//

import XCTest
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

        XCTAssert((main != nil) && (detail != nil) && (detailError == nil))
    }

    func testShowRoot() {
        do {
            let route = Route(routePath: .main)
            try router.showRoute(route: route, data: nil)
            let vc = router.topVC
            let hasNav = vc?.navigationController
            let classIsOK = vc is MainViewController

            XCTAssert((hasNav != nil) && classIsOK)
        } catch(let err) {
            debugPrint(err)
        }


    }

    func testShowDetail() {
        let mainExpectation = expectation(description: "Detail show")

        let route = Route(routePath: .detail)

        do {
            // data - just po pass nill checks
            try router.showRoute(route: route, data: 22, completion: { VC in
                mainExpectation.fulfill()
            })
        } catch(let err) {
            debugPrint(err)
        }

        waitForExpectations(timeout: 5) { error in
            let hasNav = self.router.topVC?.navigationController
            let classIsOK = self.router.topVC as? DetailViewController

            XCTAssert((hasNav != nil) && classIsOK != nil)

        }
    }

}
