//
//  MonthPickerCollectionViewCell.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/5/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

/// A class to display a month in the month picker
open class MonthPickerCollectionViewCell: UICollectionViewCell {

    @IBOutlet open weak var label: UILabel?

    /// Displays the month in that view
    ///
    /// The default implementation displays the month symbol
    ///
    /// - Parameters:
    ///   - month: a month Int
    ///   - calendar: a calendar
    open func setMonth(for date: Date, in calendar: Calendar) {
        let month = calendar.component(.month, from: date)
        label?.text = calendar.monthSymbols[month - 1]
    }

    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            layoutAttributes.size = size
            return layoutAttributes
    }

    open override var isSelected: Bool {
        didSet {
            label?.isHighlighted = isSelected
        }
    }
    
}
