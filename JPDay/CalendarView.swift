//
//  CalendarView.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

open class CalendarView: UIControl {

    @IBOutlet weak var monthPickerView: UICollectionView?

    @IBOutlet weak var daysView: UICollectionView?

    open var daysViewHandler = DaysViewHandler()

    //MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
        //TODO: handle init from a frame
        fatalError("Frame init not implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        daysView.map { daysViewHandler.resetCollectionViewScrollPosition($0) }
    }

    fileprivate func setup() {

        daysView.map {
            $0.isPagingEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.delegate = daysViewHandler
            $0.dataSource = daysViewHandler
            $0.collectionViewLayout = DaysViewLayout()
            $0.reloadData()
            daysViewHandler.resetCollectionViewScrollPosition($0)
        }
    }

}
