//
//  DaysViewHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

open class DaysViewHandler: CalendarHandler,
    UICollectionViewDataSource,
    DaysViewLayoutDelegate
{
    open var numberOfWeekdays: Int = 0

    public let numberOfRows = 7

    open private(set) var visibleDate = Date()

    internal private(set) var sections: [DaysSection] = []

    public override init() {
        super.init()

        numberOfWeekdays = calendar.weekdaySymbols.count

        try? resetSections()
    }

    /// Sets up the collection view for this handler
    ///
    /// - Parameter collectionView: a collection view or nil
    open override func setup(collectionView: UICollectionView?) {

        super.setup(collectionView: collectionView)

        guard let collectionView = collectionView else {
            return
        }

        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = instantiateCollectionViewLayout()
        collectionView.reloadData()

        resetCollectionViewScrollPosition(collectionView)
    }

    /// Creates a picker layout to be used in the `setup(collectionView:) function
    ///
    /// - Returns: a layout
    open func instantiateCollectionViewLayout() -> UICollectionViewLayout {
        return DaysViewLayout()
    }

    //MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 3 pages of content
        return sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 7 columns (one for each day of the week) + 7 rows (1 for the header + 6 rows of days)
        return numberOfWeekdays * numberOfRows
    }

    open func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < numberOfWeekdays {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)

            (cell as? DaysHeaderCollectionViewCellProtocol).map {
                $0.setWeekday(indexPath.row, in: calendar)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "day", for: indexPath)
            (cell as? DayCollectionViewCellProtocol).map {
                $0.setDate(date(at: indexPath), state: [], in: calendar)
            }
            return cell

        }
    }

    /// Rebuilds the sections based on the current visible dates
    ///
    /// - Throws: An NSError when the dates could not be built
    open func resetSections() throws {
        sections = try [-1, 0, 1].map {
            guard let date = calendar.date(byAdding: .month, value: $0, to: visibleDate) else {
                throw error("Could not build date with month offset \($0) from \(visibleDate)")
            }
            return try DaysSection(calendar: calendar, date: date)
        }
    }

    //MARK: - DaysViewLayoutDelegate

    open func numberOfColumnsInDaysViewLayout(_ layout: DaysViewLayout) -> Int {
        return numberOfWeekdays
    }

    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if !decelerate {
            handleScrollEnd(scrollView: scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleScrollEnd(scrollView: scrollView)
    }

    private func handleScrollEnd(scrollView: UIScrollView) {

        guard let collectionView = scrollView as? UICollectionView else {
            return
        }

        updateVisibleDate(for: collectionView)
        collectionView.reloadData()
        resetCollectionViewScrollPosition(collectionView)
    }

    //MARK: - Convenience methods

    open func date(at indexPath: IndexPath) -> Date? {
        return sections[indexPath.section].date(at: indexPath.row - numberOfWeekdays, in: calendar)
    }

    /// Updates the visible date based on the collection view status
    ///
    /// The base implementation of this method uses the collectionView's X offset to determine if the visible
    /// date should be moved up or down a month
    ///
    /// - Parameter collectionView: a collection view
    open func updateVisibleDate(for collectionView: UICollectionView) {
        let offset = collectionView.contentOffset.x
        let width = collectionView.contentSize.width
        let month: Int
        if offset < width / 6 {
            month = -1
        } else if offset > width * 0.5 {
            month = 1
        } else {
            month = 0
        }

        guard let date = calendar.date(byAdding: .month, value: month, to: visibleDate) else {
            return
        }
        visibleDate = date
        try? resetSections()
    }

    /// Scrolls the collection view back to the center
    ///
    /// - Parameter collectionView: a collection view
    open func resetCollectionViewScrollPosition(_ collectionView: UICollectionView) {
        collectionView.contentOffset.x = collectionView.bounds.width
    }

}
