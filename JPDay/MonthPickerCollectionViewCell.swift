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

    /// A label where the month will be displayed
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

    /// Returns the size of the cell based on its constraints
    ///
    /// - Parameter layoutAttributes: a layout attribute
    /// - Returns: the same layout attributes instance, with a size computed using the cell's constraints
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutAttributes {
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            layoutAttributes.size = size
            return layoutAttributes
    }

    /// True if the cell is selected
    ///
    /// The default implementation updates the highlighted state of the label to match
    open override var isSelected: Bool {
        didSet {
            label?.isHighlighted = isSelected
        }
    }

    open func apply(highlight: Bool) {
//        label?.isHighlighted = highlight
    }
    
}
