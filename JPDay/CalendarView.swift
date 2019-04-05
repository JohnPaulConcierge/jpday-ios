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

    open var monthPickerHandler = MonthPickerHandler()

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

    open func setup() {

        daysView.map { daysViewHandler.setup(collectionView: $0) }
        monthPickerView.map { monthPickerHandler.setup(collectionView: $0) }
    }

}
