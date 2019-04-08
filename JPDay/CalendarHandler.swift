//
//  CalendarHandler.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/5/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

/// A base class for calendar components handler
open class CalendarHandler: NSObject,
    UICollectionViewDelegate
{

    open internal(set) var calendar = defaultCalendar

    /// The minimum date displayed
    ///
    /// - Note: the behavior is weird if the `minimumDate` is set to `distantPast` for some reason.
    open internal(set) var minimumDate = Date(timeIntervalSince1970: 0)

    open internal(set) var maximumDate = Date.distantFuture

    open private(set) var collectionView: UICollectionView?

    open private(set) var isDragging: Bool = false

    open func setup(collectionView: UICollectionView?) {
        self.collectionView = collectionView
    }

    //MARK: - UICollectionViewDelegate

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isDragging = false
    }

}
