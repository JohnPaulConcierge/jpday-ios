//
//  DaysHeaderCollectionViewCell.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

public protocol DaysHeaderCollectionViewCellProtocol: class {

    func setWeekday(_ weekday: Int, in calendar: Calendar)
    
}

open class DaysHeaderCollectionViewCell: UICollectionViewCell, DaysHeaderCollectionViewCellProtocol {

    @IBOutlet open weak var label: UILabel?

    open func setWeekday(_ weekday: Int, in calendar: Calendar) {
        let symbols = calendar.veryShortWeekdaySymbols
        label?.text = weekday < symbols.count ? symbols[weekday] : nil
    }
}
