//
//  DaysSectionTests.swift
//  Tests
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import XCTest
@testable import JPDay

class DaysSectionTests: XCTestCase {

    func testOffset() {

        func check(_ year: Int, _ month: Int, _ day: Int, _ offset: Int) {
            let calendar = Calendar(identifier: .gregorian)
            let date = DateComponents(calendar: calendar, year: year, month: month, day: day).date!

            let section = try! DaysSection(calendar: calendar, date: date)

            XCTAssertEqual(offset,
                           section.dayOffset,
                           "Offset did not equal fo date \(year)-\(month)-\(day)")
        }


        check(2018, 07, 10, 0)
        check(2019, 02, 10, 5)
        check(2019, 04, 10, 1)
        check(2019, 05, 10, 3)
    }

    func testDayAtIndex() {

        let calendar = Calendar(identifier: .gregorian)

        func check(_ section: DaysSection, _ index: Int, _ year: Int, _ month: Int, _ day: Int) {
            let newDate = section.date(at: index, in: calendar)!
            let comps = calendar.dateComponents([.day, .month, .year], from: newDate)

            XCTAssertEqual(day, comps.day)
            XCTAssertEqual(month, comps.month)
            XCTAssertEqual(year, comps.year)
        }

        // Checking April 2019
        var date = DateComponents(calendar: calendar, year: 2019, month: 4, day: 1).date!
        var section = try! DaysSection(calendar: calendar, date: date)

        check(section, 0, 2019, 3, 31)
        check(section, 1, 2019, 4, 1)
        check(section, 5 * 7, 2019, 5, 5)

        // Checking December 2019 for year update
        date = DateComponents(calendar: calendar, year: 2019, month: 12, day: 1).date!
        section = try! DaysSection(calendar: calendar, date: date)

        check(section, 0, 2019, 12, 1)
        check(section, 5 * 7, 2020, 1, 5)
    }

}
