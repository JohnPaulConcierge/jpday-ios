//
//  MonthPickerHandlerTests.swift
//  Tests
//
//  Created by Guillaume Aquilina on 4/5/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import XCTest
@testable import JPDay

class MonthPickerHandlerTests: XCTestCase {

    func testMonthCount() {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        let handler = MonthPickerHandler()

        func check(_ from: String, _ to: String, _ count: Int) {
            handler.minimumDate = df.date(from: from)!
            handler.maximumDate = df.date(from: to)!

            handler.reloadData()

            XCTAssertEqual(count,
                           handler.monthCount,
                           "Count did not match for \(from) to \(to)")
        }

        check("2019-10-11", "2019-11-12", 2)
        check("2019-10-11", "2019-10-12", 1)
        check("2019-10-11", "2020-10-12", 13)

    }

    func testDateAt() {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        let handler = MonthPickerHandler()

        func check(_ min: String, _ date: String, _ index: Int) {
            handler.minimumDate = df.date(from: min)!

            let ip = handler.indexPath(for: df.date(from: date)!)
            XCTAssertEqual(index,
                           ip.row,
                           "Index did not match for \(min), \(date)")
        }

        check("2019-10-11", "2019-11-12", 1)
        check("2019-10-11", "2019-10-12", 0)
        check("2019-10-11", "2020-10-12", 12)
        check("0001-01-01", "0001-11-01", 10)
    }

    func testIndexFor() {

        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"

        let handler = MonthPickerHandler()

        func check(_ min: String, _ index: Int, _ expected: String) {
            handler.minimumDate = df.date(from: min)!

            let date = handler.date(at: index)!
            XCTAssertEqual(df.string(from: date),
                           expected,
                           "Date did not match for \(min), \(index)")

        }

        check("2019-10-11", 1, "2019-11-11")
        check("2019-10-11", 12, "2020-10-11")
        check("2019-10-11", 12, "2020-10-11")
        check("0001-01-01", 9, "0001-10-01")
    }

    func testSanityDateIndices() {

        let indices = [1, 10, 20, 30, 70]

        for index in indices {
            let handler = MonthPickerHandler()
            let date = handler.date(at: index)!

            let indexPath = handler.indexPath(for: date)

            XCTAssertEqual(index, indexPath.row, "Index: \(index)")
        }

    }

}
