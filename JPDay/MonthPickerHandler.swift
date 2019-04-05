//
//  MonthPickerHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/4/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

open class MonthPickerHandler: CalendarHandler,
    UICollectionViewDataSource,
    UICollectionViewDelegate
{
    open var collectionView: UICollectionView?

    open private(set) var monthCount = 0

    open func setup(collectionView: UICollectionView?) {
        self.collectionView = collectionView

        guard let collectionView = collectionView else {
            return
        }

        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
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
    }

    //MARK: - UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == monthSectionIndex ? monthCount : 0
    }

    public func collectionView(_ collectionView: UICollectionView,
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

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.selectItem(at: indexPath,
//                                  animated: true,
//                                  scrollPosition: [.centeredVertically, .centeredHorizontally])
//        delegate?.pickerView(collectionView, didSelectItemAtIndexPath: indexPath)
    }

    //MARK: - Misc

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
