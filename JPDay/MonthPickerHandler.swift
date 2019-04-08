//
//  MonthPickerHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/4/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

open class MonthPickerHandler: CalendarHandler,
    UICollectionViewDataSource
{
    open private(set) var monthCount = 0

    open private(set) var selectedIndex: Int = 0

    open override func setup(collectionView: UICollectionView?) {
        super.setup(collectionView: collectionView)

        guard let collectionView = collectionView else {
            return
        }

        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = instantiateCollectionViewLayout()

        reloadData()
    }

    /// Creates a picker layout to be used in the `setup(collectionView:) function
    ///
    /// - Returns: a layout
    open func instantiateCollectionViewLayout() -> UICollectionViewLayout {
        return MonthPickerLayout()
    }

    /// Reloads the content
    open func reloadData() {
        monthCount = monthDifference(from: minimumDate, to: maximumDate, in: calendar) + 1
        collectionView?.reloadData()

        try? select(index: selectedIndex, animated: false)
    }

    //MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == monthSectionIndex ? monthCount : 0
    }

    open func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section == monthSectionIndex else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month", for: indexPath)

        if let date = date(at: indexPath.row),
            let monthCell = cell as? MonthPickerCollectionViewCell {
            monthCell.setMonth(for: date, in: calendar)
        }
        return cell
    }

    //MARK: - UICollectionViewDelegate

    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath,
                                  animated: true,
                                  scrollPosition: [.centeredVertically, .centeredHorizontally])
        return false
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? MonthPickerLayout,
            let centeredItem = layout.centeredItem else {
                return
        }

        collectionView.selectItem(at: centeredItem.indexPath,
                                  animated: false,
                                  scrollPosition: [])
    }

    private func selectHighlightedItem(_ collectionView: UICollectionView) {
        guard let indexPath = (collectionView.collectionViewLayout as? MonthPickerLayout)?
            .centeredItem?.indexPath else {
            return
        }
        collectionView.selectItem(at: indexPath,
                                  animated: true,
                                  scrollPosition: [.centeredVertically, .centeredHorizontally])
//        delegate?.pickerView(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectHighlightedItem(scrollView as! UICollectionView)
    }

    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if !decelerate {
            selectHighlightedItem(scrollView as! UICollectionView)
        }
    }

//    open override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
//                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        if !freeSwipe {
//            var index = collectionViewLayout.highlightedIndexPath
//            if velocity.x > 0.1 && index.row < collectionView.numberOfItems(inSection: index.section) - 1 {
//                index.row += 1
//            } else if velocity.x < -0.1 && index.row > 0 {
//                index.row -= 1
//            }
//
//            targetContentOffset.pointee = collectionViewLayout.contentOffsetToSelect(indexPath: index)
//        }
//
//    }

    //MARK: - Misc

    /// Selects the provided month index and displays it in the month view
    ///
    /// If the index, is out of bounds, then the max possible index is selected instead.
    ///
    /// - Parameters:
    ///   - index: an index
    ///   - animated: true if the scroll should be animated
    /// - Throws: an error if the collection view is empty
    open func select(index: Int, animated: Bool) throws {
        guard let count = collectionView?.numberOfItems(inSection: monthSectionIndex),
            count > 0 else {
                throw error("Tried selecting a row in an empty collection view")
        }
        selectedIndex = min(count, selectedIndex)
        collectionView?.selectItem(at: IndexPath(row: 0, section: 0),
                                   animated: false,
                                   scrollPosition: [])
    }

    open var monthSectionIndex: Int {
        return 0
    }

    open func date(at index: Int) -> Date? {
        return calendar.date(byAdding: .month, value: index, to: minimumDate)
    }

    open func indexPath(for date: Date) -> IndexPath {
        return IndexPath(row: monthDifference(from: minimumDate, to: date, in: calendar),
                         section: monthSectionIndex)
    }

}
