//
//  CalendarHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/5/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

/// A base class for calendar components handler
open class CalendarHandler: NSObject {

    open internal(set) var calendar = Calendar(identifier: .gregorian)

    /// The minimum date displayed
    ///
    /// - Note: the behavior is weird if the `minimumDate` is set to `distantPast` for some reason.
    open internal(set) var minimumDate = Date(timeIntervalSince1970: 0)

    open internal(set) var maximumDate = Date.distantFuture

}
