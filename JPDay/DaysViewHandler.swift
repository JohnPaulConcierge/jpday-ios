//
//  DaysViewHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

open class DaysViewHandler: NSObject,
    UICollectionViewDataSource,
    DaysViewLayoutDelegate
{

    open var calendar = Calendar(identifier: .gregorian)

    open var numberOfWeekdays: Int

    public let numberOfRows = 7

    open var minimumDate = Date.distantPast

    open var maximumDate = Date.distantFuture

    open private(set) var visibleDate = Date()

    internal private(set) var sections: [DaysSection]

    public override init() {
        numberOfWeekdays = calendar.weekdaySymbols.count
        sections = []
        super.init()

        try? resetSections()
    }

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

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
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
