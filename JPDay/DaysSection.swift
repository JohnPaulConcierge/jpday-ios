//
//  DaysSection.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

struct DaysSection {

    /// The number of days that should be displayed before the first day of the month
    let dayOffset: Int

    /// The first day of the month that is displayed
    let firstDayOfMonth: Date

    /// Inits a section with a date's month
    ///
    /// - Throws: Can throw if it is not possible to find the first day of the month
    init(calendar: Calendar, date: Date) throws {

        var comps = calendar.dateComponents([.day, .month, .year], from: date)
        comps.day = 1

        guard let firstDate = calendar.date(from: comps) else {
            throw error("First day of the month components did not yield a date: \(comps)")
        }
        firstDayOfMonth = firstDate

        dayOffset = calendar.component(.weekday, from: firstDayOfMonth) - 1
    }

    func date(at index: Int, in calendar: Calendar) -> Date? {
        return calendar.date(byAdding: .day,
                             value: index - dayOffset,
                             to: firstDayOfMonth)
    }
}
