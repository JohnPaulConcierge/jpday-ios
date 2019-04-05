//
//  Utils.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

func error(_ message: String) -> NSError {
    return NSError(domain: "JPDayErrorDomain",
                   code: -1,
                   userInfo: [NSLocalizedDescriptionKey: message])
}

func monthDifference(from: Date, to: Date, in calendar: Calendar) -> Int {
    let units: Set<Calendar.Component> = [.day, .month, .year]
    return calendar.dateComponents([.month],
                                   from: calendar.dateComponents(units, from: from),
                                   to: calendar.dateComponents(units, from: to)).month ?? 0
}

var defaultCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale.autoupdatingCurrent
    return calendar
}
