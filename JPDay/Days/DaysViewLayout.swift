//
//  DaysViewLayout.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

open class DaysViewLayout: UICollectionViewLayout {

    /// The insets to display the content
    open var insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    /// The attributes. A new array is generated at each prepare
    ///
    /// Note: there is probably no need to optimize this given that this will be a short array
    private var attributes: [UICollectionViewLayoutAttributes] = []

    open override var collectionViewContentSize: CGSize {

        guard let collectionView = self.collectionView else {
            return .zero
        }

        return CGSize(width: 3 * collectionView.bounds.width,
                      height: collectionView.bounds.height)
    }

    open override func prepare() {

        attributes = []

        guard let collectionView = self.collectionView else {
            return
        }

        let collectionViewSize = collectionView.bounds.size
        let numberOfSections = collectionView.numberOfSections
        let numberOfColumns = self.numberOfColumns
        let maxNumberOfRows = (0..<numberOfSections).reduce(0) { max($0, self.numberOfRows(in: $1)) }

        guard maxNumberOfRows > 0 else {
            return
        }

        let cellWidth = round((collectionViewSize.width - insets.left - insets.right) / CGFloat(numberOfColumns))
        let cellHeight = round((collectionViewSize.height  - insets.left - insets.right) / CGFloat(maxNumberOfRows))

        for section in 0..<numberOfSections {

            let x = (CGFloat(section) * collectionViewSize.width) + insets.left
            let y = insets.top

            // index: index of the item
            for index in 0..<collectionView.numberOfItems(inSection: section) {

                let indexPath = IndexPath(row: index, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let column = CGFloat(index % numberOfColumns)
                // row: row index in the grid (not the row of the indexpath)
                let row = CGFloat(index / numberOfColumns)

                attribute.frame = CGRect(x: x + column * cellWidth,
                                         y: y + row * cellHeight,
                                         width: cellWidth,
                                         height: cellHeight)
                attributes.append(attribute)
            }
        }
    }

    open var numberOfColumns: Int {
        return (collectionView?.delegate as? DaysViewLayoutDelegate)?.numberOfColumnsInDaysViewLayout(self) ?? 7
    }

    open func numberOfRows(in section: Int) -> Int {
        return Int(ceil(CGFloat(collectionView?.numberOfItems(inSection: section) ?? 0) / CGFloat(numberOfColumns)))
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter {
            rect.intersects($0.frame)
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes.first {
            $0.indexPath == indexPath
        }
    }
    
}
