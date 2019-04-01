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
