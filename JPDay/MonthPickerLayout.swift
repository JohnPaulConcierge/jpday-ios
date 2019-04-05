//
//  MonthPickerLayout.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/4/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import Foundation

/// A layout that magnetizes an item in the center
open class MonthPickerLayout: UICollectionViewLayout {

    /// The path that is in the center of the layout or nil if the content is empty
    var highlightedIndexPath: IndexPath? = nil

    /// The estimated width of an item
    open var estimatedCellWidth: CGFloat = 150

    /// The attributes that were computed
    fileprivate var cachedAttributes = [UICollectionViewLayoutAttributes]()

    /// The max X coordinate of all cached attributes
    fileprivate var cachedAttributesMaxX: CGFloat = 0

    public override required init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: - Overrides

    /// Overrides the `shouldInvalidateLayout(forBoundsChange:)` method
    ///
    /// Clears the attribute cache if the bounds changed
    ///
    /// Always returns true
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.size != collectionViewBounds.size {
            cachedAttributes.removeAll()
            return true
        }
        return false
    }

    /// The collection view content size
    ///
    /// - If all cell attributes were calculated, returns the max X coordinated of the attributes
    /// - If not, then returns the max X plus an estimation of the size of the remaining cells
    open override var collectionViewContentSize: CGSize {

        let size: CGFloat
        let countDif = CGFloat(numberOfItems - cachedAttributes.count)
        if countDif == 0 {
            size = cachedAttributesMaxX
        } else {
            size = cachedAttributesMaxX
                + estimatedCellWidth * countDif
                + collectionViewBounds.width * 0.5
        }

        return CGSize(width: size, height: collectionViewBounds.height)
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        try? cacheAttributes(until: rect.maxX)
        
        return cachedAttributes.filter {
            $0.frame.minX <= rect.maxX && $0.frame.maxX >= rect.minX
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.row < cachedAttributes.count {
            return cachedAttributes[indexPath.row]
        } else {
            let a = UICollectionViewLayoutAttributes()
            a.frame = CGRect(x: 0, y: 0, width: estimatedCellWidth, height: collectionViewBounds.height)
            return a
        }
    }

    //MARK: - Convenience methods

    open func contentOffsetToSelect(indexPath: IndexPath) -> CGPoint? {
        try? cacheAttributes(until: indexPath)

        guard indexPath.row < cachedAttributes.count else {
            return nil
        }
        let frame = cachedAttributes[indexPath.row].frame
        return CGPoint(x: frame.minX - (collectionViewBounds.width - frame.width) * 0.5, y: 0)
    }

    open var centeredItem: (indexPath: IndexPath, dx: CGFloat)? {
        guard let collectionView = collectionView else {
            return nil
        }

        try? cacheAttributes(until: collectionView.contentOffset.x + collectionView.bounds.width)
        return findCenterIndexPath(inAttributes: cachedAttributes)
    }


    //MARK: - Private methods

    /// The collection view bounds or zero
    private var collectionViewBounds: CGRect {
        return collectionView?.bounds ?? .zero
    }

    /// The number of items in the collection view or zero
    private var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    /// Finds the index path at the center of the displayed view
    private func findCenterIndexPath(inAttributes attrs: [UICollectionViewLayoutAttributes])
        -> (indexPath: IndexPath, dx: CGFloat)? {

            guard !attrs.isEmpty, let collectionView = collectionView else {
                return nil
            }

            var offset = CGFloat.infinity
            var indexPath = IndexPath(row: 0, section: 0)

            //TODO: we should probably stop processing this when the offset starts to increase...
            for a in attrs {
                let temp = a.frame.midX - collectionView.contentOffset.x - collectionView.bounds.width * 0.5
                if abs(temp) < abs(offset) {
                    offset = temp
                    indexPath = a.indexPath
                }
            }

            return (indexPath: indexPath, dx: offset)
    }

    open func preferredAttributes(at indexPath: IndexPath,
                                  fitting attributes: UICollectionViewLayoutAttributes) throws
        -> UICollectionViewLayoutAttributes {

            guard let collectionView = collectionView,
                let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) else {
                    throw error("Could not cache next attribute")
            }
            return cell.preferredLayoutAttributesFitting(attributes)
    }
}

fileprivate extension MonthPickerLayout {

    func cacheAttributes(until maxX: CGFloat) throws {
        while cachedAttributesMaxX < maxX && cachedAttributes.count < numberOfItems {
            try cacheNextAttributes()
        }
    }

    func cacheAttributes(until indexPath: IndexPath) throws {
        while cachedAttributes.count <= indexPath.row && cachedAttributes.count < numberOfItems {
            try cacheNextAttributes()
        }

    }

    private func cacheNextAttributes() throws {
        let bounds = collectionViewBounds
        let indexPath = IndexPath(row: cachedAttributes.count, section: 0)

        var attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame.size.height = bounds.height
        attributes.frame.size.width = estimatedCellWidth

        attributes = try preferredAttributes(at: indexPath, fitting: attributes)
        attributes.frame.origin.y = (bounds.height - attributes.frame.height) * 0.5

        if cachedAttributes.isEmpty {
            cachedAttributesMaxX = bounds.width * 0.5 - attributes.frame.width * 0.5
        }

        attributes.frame.origin.x = cachedAttributesMaxX
        cachedAttributes.append(attributes)
        cachedAttributesMaxX = attributes.frame.maxX

        if cachedAttributes.count == numberOfItems {
            cachedAttributesMaxX += bounds.width * 0.5 - attributes.frame.width * 0.5
        }
    }
}
