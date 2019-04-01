//
//  DayCollectionViewCell.swift
//  JPDay
//
//  Created by Guillaume Aquilina on 4/1/19.
//  Copyright © 2019 John Paul Concierge. All rights reserved.
//

import UIKit

public protocol DayCollectionViewCellProtocol: class {

    func setDate(_ date: Date?, state: Set<DayOption>, in calendar: Calendar)

}

open class DayCollectionViewCell: UICollectionViewCell, DayCollectionViewCellProtocol {

    @IBOutlet open weak var label: UILabel?

    open func setDate(_ date: Date?, state: Set<DayOption>, in calendar: Calendar) {
        guard let date = date else {
            return
        }
        label?.text = calendar.component(.day, from: date).description
    }
}
