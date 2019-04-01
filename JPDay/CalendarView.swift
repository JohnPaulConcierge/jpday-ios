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

    fileprivate func setup() {
        daysView?.isPagingEnabled = true
        daysView?.delegate = daysViewHandler
        daysView?.dataSource = daysViewHandler
        daysView?.collectionViewLayout = DaysViewLayout()
        daysView?.reloadData()
    }

}
