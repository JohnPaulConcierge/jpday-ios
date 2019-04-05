//
//  UtilsTests.swift
//  Tests
//
//  Created by Guillaume Aquilina on 4/5/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import XCTest
@testable import JPDay

class UtilsTests: XCTestCase {

    func testMonthDifference() {

        let calendar = Calendar(identifier: .gregorian)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        func check(_ from: String, _ to: String, _ expected: Int) {
            let diff = monthDifference(from: df.date(from: from)!,
                                       to: df.date(from: to)!,
                                       in: calendar)

            XCTAssertEqual(diff,
                           expected,
                           "Not matching for \(from) \(to)")
        }

        check("0001-01-01", "0001-10-01", 9)
        check("0001-01-01", "0001-01-01", 0)

        check("0001-01-01", "0002-01-01", 12)
        check("0001-01-01", "0002-05-01", 16)
    }

}
